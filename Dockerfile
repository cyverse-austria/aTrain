#FROM debian:latest
# https://github.com/JuergenFleiss/aTrain/pull/21
# docker build -t mbwali/atrain:latest .
# https://github.com/SjDayg/aTrain/tree/main
# docker run -it -p 8080:8080 mbwali/atrain:latest
FROM python:3.11-bullseye

RUN apt update && apt install -y ffmpeg
RUN pip3 install aTrain@git+https://github.com/cyverse-austria/aTrain.git@docker --extra-index-url https://download.pytorch.org/whl/cu118
RUN aTrain init

EXPOSE 8080

ENTRYPOINT ["aTrain", "startserver"]

