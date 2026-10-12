
#!/usr/bin/env bash
set -euo pipefail

cargo build --release --locked
case "$(uname -s)" in
  Darwin) library=libcalcit_http.dylib ;;
  Linux) library=libcalcit_http.so ;;
  *) echo "Unsupported platform; copy calcit_http.dll from the release build on Windows." >&2; exit 1 ;;
esac
mkdir -p dylibs/
cp -v "target/release/$library" dylibs/
