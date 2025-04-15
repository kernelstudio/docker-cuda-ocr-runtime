# Cuda:12.4.1 PaddleOCR 基础镜像

## 1. 制作本地镜像

```shell
sh build.sh
```

## 2. 测试是否安装正确

```shell
docker run --gpus all --name cuda-ocr-runtime -it cuda-ocr-runtime:12.4.1 python -c "import paddle; print(paddle.device.get_device())"
```

## 3. 删除测试容器

```shell
docker rm cuda-ocr-runtime
```
