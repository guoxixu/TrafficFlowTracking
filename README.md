# TrafficFlowTracking

Given all detection results(bounding boxes), get the traffic flow(trajectories of all cars).

The data format comes from "MOTChallenge 2015: Towards a Benchmark for Multi-Target Tracking": https://arxiv.org/pdf/1504.01942.pdf

Input: dt.txt(ordered by frame numbers), format: <FrameNumber, -1, x_left, y_up, dx, dy, Confidence, ObjectType, -1, -1>

Output: tracking.txt(ordered by tracklets/objects), format: <FrameNumber, ObjectId, x_left, y_up, width, height, 1, 1, 0, 0>

Output: centerpoints.txt(ordered by tracklets/objects), format: <FrameNumber, ObjectId, x_center, y_center>

See experiment folder for examples.
  
---
  
TrafficFlowTracking使用说明(由于中文编码问题，请用MATLAB或记事本编辑本文档)

By Guoxi XU, 2018.11(2019.09重构)

TrafficFlowTracking是一套用于从现实世界采集的录像数据（一般是高空俯拍）和检测结果当中还原车流信息的工具。其对车流信息（例如每个时刻车辆的位置、速度、之前轨迹）的还原准确程度依赖于检测结果。

检测一般使用Faster-RCNN或其他目标检测框架，给出bounding box和置信度。（这一步依赖外界输入）

在追踪步骤中，我们过滤掉置信度过低的bounding box，并用非极大值抑制选出重叠度低的bounding box作为最终检测结果，然后维护一个临时轨迹库。内存中存有最近的N帧的完整图片，一般取N = 20~40，太小会导致一旦漏检则轨迹中断，太大则占用内存。每一帧的检测结果拿出来去和前面的所有轨迹比较，如果符合某种条件（即某一特定的检测框能够匹配上一个已经存在的轨迹），则该轨迹延长一帧。用于判断检测框和已有轨迹关系的变量包括IOU重合度、（距离损失 + 长宽比损失）× 图像内容损失、猜测位置和实际位置的距离损失等。如一个检测框与之前所有轨迹的关系均不符合如上条件，则认为它是一条新的轨迹。每帧结束之后，维护一个尚存活的轨迹列表。新的检测框可能成为这些轨迹的延长，或成为一条新轨迹的起始帧。对于非存活的轨迹，则不再处理。最后我们筛选出临时轨迹库中的所有合法轨迹，利用插值补充中间丢掉的帧，并输出到文件。

本算法对检测的丢帧有较好的鲁棒性，只要丢帧不严重，基本可以保证车辆的编号不丢失，不交换id。
