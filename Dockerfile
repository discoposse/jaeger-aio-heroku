# Use the official Jaeger all-in-one image
FROM jaegertracing/all-in-one:latest

# Expose necessary ports
EXPOSE 5775/udp 6831/udp 6832/udp 5778 16686 14268 14250 4317 4318

# Start Jaeger all-in-one
CMD ["/go/bin/all-in-one-linux"]