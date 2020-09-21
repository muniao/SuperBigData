#!/bin/sh

if [ -z "${1}" ]; then
  echo "Usage: ${0} <image> --enable-security-manager"
  exit 1
fi

target_image="${1}"

dockerfile="
FROM        ${target_image}
WORKDIR     /var/tmp
RUN         printf ' \\
              public class DNSTTLPolicy { \\
                public static void main(String args[]) { \\
                  System.out.printf(\"Implementation DNS TTL for JVM in Docker image based on '${target_image}' is %%d seconds\\\\n\", sun.net.InetAddressCachePolicy.get()); \\
                } \\
              }' >DNSTTLPolicy.java
RUN         javac DNSTTLPolicy.java -XDignore.symbol.file
CMD         java DNSTTLPolicy
ENTRYPOINT  java DNSTTLPolicy
"

dockerfile_security_manager="
FROM        ${target_image}
WORKDIR     /var/tmp
RUN         printf ' \\
              public class DNSTTLPolicy { \\
                public static void main(String args[]) { \\
                  System.out.printf(\"Implementation DNS TTL for JVM in Docker image based on '${target_image}' (with security manager enabled) is %%d seconds\\\\n\", sun.net.InetAddressCachePolicy.get()); \\
                } \\
              }' >DNSTTLPolicy.java
RUN         printf ' \\
              grant { \\
                permission java.security.AllPermission; \\
              };' >all-permissions.policy
RUN         javac DNSTTLPolicy.java -XDignore.symbol.file
CMD         java -Djava.security.manager -Djava.security.policy==all-permissions.policy DNSTTLPolicy
ENTRYPOINT  java -Djava.security.manager -Djava.security.policy==all-permissions.policy DNSTTLPolicy
"

target_dockerfile="${dockerfile}"
if [ -n "${2}" ] && [ "${2}" == "--enable-security-manager" ]; then
  target_dockerfile="${dockerfile_security_manager}"
fi

tag_name="jvm-dns-ttl-policy"
output_file="$(mktemp)"

function cleanup() {
  rm "${output_file}"
  docker rmi "${tag_name}" >/dev/null
}

trap "cleanup; exit" SIGHUP SIGINT SIGTERM

echo "Building Docker image based on ${target_image} ..." >&2
docker build -t "${tag_name}" - <<<"${target_dockerfile}" &>"${output_file}"

if [ "$?" -ne 0 ]; then
  >&2 echo "Error building test image:"
  cat "${output_file}"
  cleanup
  exit 1
fi

echo "Testing DNS TTL ..." >&2
docker run --rm "${tag_name}" &>"${output_file}"

if [ "$?" -ne 0 ]; then
  >&2 echo "Error running test image:"
  cat "${output_file}"
  cleanup
  exit 1
fi

cat "${output_file}"

cleanup
