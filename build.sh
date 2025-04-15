#!/bin/bash

# 通过代理下载基础的cuda镜像
docker pull docker.m.daocloud.io/nvidia/cuda:12.4.1-cudnn-runtime-ubuntu20.04
docker tag docker.m.daocloud.io/nvidia/cuda:12.4.1-cudnn-runtime-ubuntu20.04 nvidia/cuda:12.4.1-cudnn-runtime-ubuntu20.04
docker rmi docker.m.daocloud.io/nvidia/cuda:12.4.1-cudnn-runtime-ubuntu20.04

docker build -t cuda-ocr-runtime:12.4.1 .