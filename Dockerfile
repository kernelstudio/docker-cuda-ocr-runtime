FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu20.04

# 安装基础工具
RUN export DEBIAN_FRONTEND=noninteractive  && \
    apt-get update -y && \
    apt-get install wget python3 python3-pip -y && \
    ln -s /usr/bin/python3 /usr/bin/python

# 安装系统图形库（解决 OpenCV/PyMuPDF 依赖）
RUN export DEBIAN_FRONTEND=noninteractive  && \
    apt-get install -y \
    libgomp1 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6

# 清理
RUN export DEBIAN_FRONTEND=noninteractive  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 下载基础模型,避免内网环境下载失败
RUN mkdir -p /root/.paddleocr/whl/det/ch/ch_PP-OCRv4_det_infer/ && \
    cd /root/.paddleocr/whl/det/ch/ch_PP-OCRv4_det_infer/ && \
    wget https://paddleocr.bj.bcebos.com/PP-OCRv4/chinese/ch_PP-OCRv4_det_infer.tar && \
    mkdir -p /root/.paddleocr/whl/rec/ch/ch_PP-OCRv4_rec_infer/ && \
    cd /root/.paddleocr/whl/rec/ch/ch_PP-OCRv4_rec_infer/ && \
    wget https://paddleocr.bj.bcebos.com/PP-OCRv4/chinese/ch_PP-OCRv4_rec_infer.tar && \
    mkdir -p /root/.paddleocr/whl/cls/ch_ppocr_mobile_v2.0_cls_infer/ && \
    cd /root/.paddleocr/whl/cls/ch_ppocr_mobile_v2.0_cls_infer/ && \
    wget https://paddleocr.bj.bcebos.com/dygraph_v2.0/ch/ch_ppocr_mobile_v2.0_cls_infer.tar


COPY requirements.txt .
RUN pip3 install -i https://mirrors.aliyun.com/pypi/simple/ -r requirements.txt

# 设置容器启动时执行的命令
CMD ["/bin/sh"]