FROM alpine:latest

# stessa versione del locale (`./backend/pocketbase --version`)
ARG PB_VERSION=0.39.7

RUN apk add --no-cache unzip ca-certificates curl

WORKDIR /pb

RUN curl -L "https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip" -o pb.zip \
    && unzip pb.zip -d /pb \
    && rm pb.zip \
    && chmod +x /pb/pocketbase

# COPY backend/pb_migrations /pb/pb_migrations
COPY backend/pb_data /pb/pb_data

EXPOSE 8090

# Railway espone la porta tramite variabile $PORT
CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8090"]
