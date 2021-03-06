#!/bin/sh

VERSION=${VERSION:-"0.11.0"}
TELEMETRY=${ENABLE_TELEMETRY:-"true"}

# caddy
git clone https://github.com/icasei/caddy -b "v$VERSION" /go/src/github.com/icasei/caddy \
    && cd /go/src/github.com/icasei/caddy \
    && git checkout -b "v$VERSION"

# plugin helper
GOOS=linux GOARCH=amd64 go get -v github.com/icasei/caddyplug/caddyplug
alias caddyplug='GOOS=linux GOARCH=amd64 caddyplug'

# telemetry
run_file="/go/src/github.com/icasei/caddy/caddy/caddymain/run.go"
line=$(awk '/const enableTelemetry = true/{print NR}' $run_file)
if [ "$line" ] && [ $TELEMETRY = "false" ]; then
    sed -i.bak -e "${line}d" $run_file
    cat > "$run_file.disablestats.go" <<EOF
    package caddymain
    import "os"
    var enableTelemetry = $TELEMETRY
    func init() {
        switch os.Getenv("ENABLE_TELEMETRY") {
        case "0", "false":
            enableTelemetry = false
        case "1", "true":
            enableTelemetry = true
        }
    }
EOF
fi

# plugins
for plugin in $(echo $PLUGINS | tr "," " "); do \
    go get -v $(caddyplug package $plugin); \
    printf "package caddyhttp\nimport _ \"$(caddyplug package $plugin)\"" > \
        /go/src/github.com/icasei/caddy/caddyhttp/$plugin.go ; \
    done

# builder dependency
git clone https://github.com/icasei/builds /go/src/github.com/icasei/builds

# build
cd /go/src/github.com/icasei/caddy/caddy \
    && GOOS=linux GOARCH=amd64 go run build.go -goos=$GOOS -goarch=$GOARCH -goarm=$GOARM \
    && mkdir -p /install \
    && mv caddy /install
