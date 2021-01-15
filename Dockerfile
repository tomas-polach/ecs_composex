﻿ARG ARCH=
ARG SRC_TAG=3.7.20210113
ARG BASE_IMAGE=public.ecr.aws/i9v7p2w3/python:${SRC_TAG}${ARCH}
FROM $BASE_IMAGE as builder

COPY ecs_composex       /opt/ecs_composex
COPY setup.py           /opt/setup.py
COPY requirements.txt   /opt/requirements.txt

WORKDIR /opt
RUN python -m venv venv ; source venv/bin/activate ; pip install wheel;  python setup.py sdist bdist_wheel; ls -l dist/

FROM $BASE_IMAGE
COPY --from=builder /opt/dist/ecs_composex-*.whl /opt/
WORKDIR /opt
RUN pip install *.whl --no-cache-dir
WORKDIR /tmp
ENTRYPOINT ["ecs-composex"]
