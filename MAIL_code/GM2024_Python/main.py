"""
Copyright 2024 Yanbin Lin. All rights reserved.
This code is written by Yanbin Lin in 2023.
If this code is used for any research purpose, please cite our PESGM’24 paper below.
Yanbin Lin, Zhen Ni, and Yufei Tang, “An Imitation Learning Method with Multi virtual Agents for Microgrid Energy Optimization under Interrupted Periods,” in Proc. of IEEE Power & Energy Society General Meeting (PESGM’24), pp.1-5, Washington, DC, USA, Jul. 21-25, 2024. 
"""

import numpy as np
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split
import pandas as pd
import xlrd
import tensorflow as tf
from tensorflow import keras
from keras import layers


def excel_to_matrix(name):
    table = xlrd.open_workbook(name).sheets()[0]
    row = table.nrows
    col = table.ncols
    datamatrix = np.zeros((row,col))
    for x in range(col):
        cols = np.matrix(table.col_values(x))
        datamatrix[:,x] = cols
    return datamatrix


data1 = excel_to_matrix('interrupt10-13_dp51.xls')
data2 = excel_to_matrix('interrupt11-14_dp51.xls')
data3 = excel_to_matrix('interrupt12-15_dp51.xls')
data = excel_to_matrix('interrupt10-15_dp51.xls')
X1_ = data1[:,0:8]
Y1_ = data1[:,8]
X2_ = data2[:,0:8]
Y2_ = data2[:,8]
X3_ = data3[:,0:8]
Y3_ = data3[:,8]
X_= data[:,0:8]
Y_ = data[:,8]
PredictorScaler = MinMaxScaler()
TargetVarScaler = MinMaxScaler()
# Storing the fit object for later reference
PredictorScalerFit1 = PredictorScaler.fit(X1_)
TargetVarScalerFit1 = TargetVarScaler.fit(Y1_.reshape(-1, 1))
PredictorScalerFit2 = PredictorScaler.fit(X2_)
TargetVarScalerFit2 = TargetVarScaler.fit(Y2_.reshape(-1, 1))
PredictorScalerFit3 = PredictorScaler.fit(X3_)
TargetVarScalerFit3 = TargetVarScaler.fit(Y3_.reshape(-1, 1))
PredictorScalerFit = PredictorScaler.fit(X_)
TargetVarScalerFit = TargetVarScaler.fit(Y_.reshape(-1, 1))

# Generating the standardized values of X and y
X1 = PredictorScalerFit1.transform(X1_)
Y1 = TargetVarScalerFit1.transform(Y1_.reshape(-1, 1))
X2 = PredictorScalerFit2.transform(X2_)
Y2 = TargetVarScalerFit2.transform(Y2_.reshape(-1, 1))
X3 = PredictorScalerFit3.transform(X3_)
Y3 = TargetVarScalerFit3.transform(Y3_.reshape(-1, 1))
X = PredictorScalerFit.transform(X_)
Y = TargetVarScalerFit.transform(Y_.reshape(-1, 1))

model = keras.Sequential()
model.add(layers.Dense(500, kernel_initializer='normal', input_shape=(8,)))
model.add(layers.Activation('relu'))
model.add(layers.Dense(1000,kernel_initializer='normal'))
model.add(layers.Activation('relu'))
model.add(layers.Dense(500,kernel_initializer='normal'))
model.add(layers.Activation('relu'))
model.add(layers.Dense(1,kernel_initializer='normal'))
model.add(layers.Activation('relu'))

# Compiling the model
loss_fn = tf.keras.losses.MeanSquaredError()
optimizer = tf.keras.optimizers.Adam()
X1 = tf.convert_to_tensor(X1)
Y1 = tf.convert_to_tensor(Y1)
X2 = tf.convert_to_tensor(X2)
Y2 = tf.convert_to_tensor(Y2)
X3 = tf.convert_to_tensor(X3)
Y3 = tf.convert_to_tensor(Y3)
X = tf.convert_to_tensor(X)
for run in range(10000):
    with tf.GradientTape() as tape:
        Y1_P = model(X1)
        loss11 = loss_fn(Y1,Y1_P)
        loss12 = loss_fn(Y2,Y1_P)
        loss13 = loss_fn(Y3, Y1_P)
        loss1 = max(loss11,loss12,loss13)
        Y2_P = model(X2)
        loss21 = loss_fn(Y1, Y2_P)
        loss22 = loss_fn(Y2, Y2_P)
        loss23 = loss_fn(Y3, Y2_P)
        loss2 = max(loss21, loss22, loss23)
        Y3_P = model(X3)
        loss31 = loss_fn(Y1, Y3_P)
        loss32 = loss_fn(Y2, Y3_P)
        loss33 = loss_fn(Y3, Y3_P)
        loss3 = max(loss31, loss32, loss33)
        #loss_value = (loss11+loss12+loss13+loss21+loss22+loss23+loss31+loss32+loss33)/9
        loss_value = (loss1 + loss2 + loss3)/3 # average max loss value of three agents
        #loss_value = (loss11 + loss22 + loss33)/3
    # Update the weights of the model to minimize the loss value.
    gradients = tape.gradient(loss_value, model.trainable_weights)
    optimizer.apply_gradients(zip(gradients, model.trainable_weights))

Y_P = model.predict(X)
Predictions = TargetVarScalerFit.inverse_transform(Y_P)
np.savetxt('policy10-15_max_dp51.csv', Predictions,delimiter=',')

