FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu20.04

# 修复链接库的问题
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
ENV PATH=/usr/local/cuda/bin${PATH:+:${PATH}}

WORKDIR /app

# 安装基础工具
RUN export DEBIAN_FRONTEND=noninteractive  && \
    apt-get update -y && \
    apt-get install wget python3 python3-pip cmake gcc python3-venv g++ build-essential -y && \
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

# 解决 Cannot load cudnn shared library. Cannot invoke method cudnnGetVersion 的错误
RUN ln -s /usr/lib/x86_64-linux-gnu/libcudnn.so.9 /usr/lib/x86_64-linux-gnu/libcudnn.so && \
    ln -s /usr/local/cuda-12.4/targets/x86_64-linux/lib/libcublas.so.12 /usr/lib/x86_64-linux-gnu/libcublas.so

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

# 安装ocr依赖
RUN cd /app &&  python3 -m venv .venv && source .venv/bin/activate
COPY requirements.txt .
RUN pip3 install -i https://mirrors.aliyun.com/pypi/simple/ -r requirements.txt

# 设置容器启动时执行的命令
CMD ["/bin/sh"]