FROM node:20-alpine
WORKDIR /app

# Build args supplied by workflow
ARG BMAD_REPO=https://github.com/bmad-code-org/BMAD-METHOD.git
ARG BMAD_REF=main

RUN apk add --no-cache git bash
RUN git clone --depth 1 --branch "${BMAD_REF}" "${BMAD_REPO}" .
RUN npm ci && npm run build

# Simple CLI shim: "bmad generate --input <file> --out <dir>"
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]