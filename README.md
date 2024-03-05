# Multi-virtual-agent-Imitation-Learning-for-Microgrid-Energy-Scheduling (MAIL)
This is an open-code for our PESGM 2024 paper: An Imitation Learning Method with Multi-Virtual Agents for Microgrid Energy Optimization under Interrupted Periods.

## **Set Up**

**This code requires:**

•	MATLAB

•	Python

•	sklearn/tensorflow/keras/numpy/xlrd/pandas libraries

## **Data Preparation**

To investigate the impact of power supply interruptions on the microgrid operations, **we assume during extreme weather-related events, the utility grid goes down for a certain period, and the microgrid operates in an isolated mode during this period**. The **RG outputs** are taken from the system advisory model by **the National Renewable Energy Laboratory for the city of Phoenix, AZ (https://sam.nrel.gov/)**. For the load-demand, **a small residential community load-demand data** is collected from **https://openei.org/wiki/Data**.

### Example of Data Generation

Here is an example to generate data for the latter implementation of our proposed **MAIL** method.
