# TrafficFlowTracking

Given all detection results(bounding boxes), get the traffic flow(trajectories of all cars).

The data format comes from "MOTChallenge 2015: Towards a Benchmark for Multi-Target Tracking": https://arxiv.org/pdf/1504.01942.pdf

Input: dt.txt(ordered by frame numbers), format: <FrameNumber, -1, x_left, y_up, dx, dy, Confidence, ObjectType, -1, -1>

Output: tracking.txt(ordered by tracklets/objects), format: <FrameNumber, ObjectId, x_left, y_up, width, height, 1, 1, 0, 0>

Output: centerpoints.txt(ordered by tracklets/objects), format: <FrameNumber, ObjectId, x_center, y_center>

See experiment folder for examples.
  
---
  
TrafficFlowTrackingʹ��˵��(�������ı������⣬����MATLAB����±��༭���ĵ�)

By Guoxi XU, 2018.11(2019.09�ع�)

TrafficFlowTracking��һ�����ڴ���ʵ����ɼ���¼�����ݣ�һ���Ǹ߿ո��ģ��ͼ�������л�ԭ������Ϣ�Ĺ��ߡ���Գ�����Ϣ������ÿ��ʱ�̳�����λ�á��ٶȡ�֮ǰ�켣���Ļ�ԭ׼ȷ�̶������ڼ������

���һ��ʹ��Faster-RCNN������Ŀ�����ܣ�����bounding box�����Ŷȡ�����һ������������룩

��׷�ٲ����У����ǹ��˵����Ŷȹ��͵�bounding box�����÷Ǽ���ֵ����ѡ���ص��ȵ͵�bounding box��Ϊ���ռ������Ȼ��ά��һ����ʱ�켣�⡣�ڴ��д��������N֡������ͼƬ��һ��ȡN = 20~40��̫С�ᵼ��һ��©����켣�жϣ�̫����ռ���ڴ档ÿһ֡�ļ�����ó���ȥ��ǰ������й켣�Ƚϣ��������ĳ����������ĳһ�ض��ļ����ܹ�ƥ����һ���Ѿ����ڵĹ켣������ù켣�ӳ�һ֡�������жϼ�������й켣��ϵ�ı�������IOU�غ϶ȡ���������ʧ + �������ʧ���� ͼ��������ʧ���²�λ�ú�ʵ��λ�õľ�����ʧ�ȡ���һ��������֮ǰ���й켣�Ĺ�ϵ����������������������Ϊ����һ���µĹ켣��ÿ֡����֮��ά��һ���д��Ĺ켣�б��µļ�����ܳ�Ϊ��Щ�켣���ӳ������Ϊһ���¹켣����ʼ֡�����ڷǴ��Ĺ켣�����ٴ����������ɸѡ����ʱ�켣���е����кϷ��켣�����ò�ֵ�����м䶪����֡����������ļ���

���㷨�Լ��Ķ�֡�нϺõ�³���ԣ�ֻҪ��֡�����أ��������Ա�֤�����ı�Ų���ʧ��������id��
