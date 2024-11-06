import time
import board
from adafruit_lsm6ds.lsm6dsox import LSM6DSOX as LSM6DS

from adafruit_lis3mdl import LIS3MDL


import digitalio
import adafruit_rfm69

# Define radio frequency in MHz. Must match your
# module. Can be a value like 915.0, 433.0, etc.
RADIO_FREQ_MHZ = 915.0

# Define Chip Select and Reset pins for the radio module.
CS = digitalio.DigitalInOut(board.RFM_CS)
RESET = digitalio.DigitalInOut(board.RFM_RST)

# Initialise RFM69 radio
rfm69 = adafruit_rfm69.RFM69(board.SPI(), CS, RESET, RADIO_FREQ_MHZ)


i2c = board.I2C()  # uses board.SCL and board.SDA
accel_gyro = LSM6DS(i2c)
mag = LIS3MDL(i2c)

# Threshold for detecting gestures
TILT_THRESHOLD = 7.0 # Adjust based on sensitivity
SHAKE_THRESHOLD = 20.0
SOFT_SHAKE_THRESHOLD = 10.0
HARD_SHAKE_THRESHOLD = 20.0

def detect_soft_shake(accel_x, accel_y, accel_z):
    if (
        SOFT_SHAKE_THRESHOLD < abs(accel_x) <= HARD_SHAKE_THRESHOLD or
        SOFT_SHAKE_THRESHOLD < abs(accel_y) <= HARD_SHAKE_THRESHOLD or
        SOFT_SHAKE_THRESHOLD < abs(accel_z) <= HARD_SHAKE_THRESHOLD
    ):
        return "Soft Shake detected"
    return None


def detect_tilt(accel_x, accel_y, accel_z):
    if accel_x > TILT_THRESHOLD:
        return "right"
    elif accel_x < -TILT_THRESHOLD:
        return "left"
    elif accel_y > TILT_THRESHOLD:
        return "up"
    elif accel_y < -TILT_THRESHOLD:
        return "down"

    return None


    '''
    if accel_x > TILT_THRESHOLD:
        return "Tilted Right"
    elif accel_x < -TILT_THRESHOLD:
        return "Tilt Left"
    elif accel_y > TILT_THRESHOLD:
        return "Tilt Forward"
    elif accel_y < -TILT_THRESHOLD:
        return "Tilt Backward"
    '''

def detect_shake(accel_x, accel_y, accel_z):
    if abs(accel_x) > SHAKE_THRESHOLD or abs(accel_y) > SHAKE_THRESHOLD or abs(accel_z) > SHAKE_THRESHOLD:
       return "Shake detected"
    return None


def check_device():
    acceleration = accel_gyro.acceleration
    gyro = accel_gyro.gyro
    magnetic = mag.magnetic
    print(
        "Acceleration: X:{0:7.2f}, Y:{1:7.2f}, Z:{2:7.2f} m/s^2".format(*acceleration)
    )
    print("Gyro          X:{0:7.2f}, Y:{1:7.2f}, Z:{2:7.2f} rad/s".format(*gyro))
    print("Magnetic      X:{0:7.2f}, Y:{1:7.2f}, Z:{2:7.2f} uT".format(*magnetic))
    print("")
    time.sleep(0.5)


count = 0

while True:
    acceleration = accel_gyro.acceleration
    tilt = detect_tilt(*acceleration)
    shake = detect_shake(*acceleration)

    if shake:
        print("shake")
        rfm69.send(bytes("shake", "UTF-8"))

    elif tilt:
        print(tilt)
        rfm69.send(bytes(tilt, "UTF-8"))

    #if shake:
    #    print(shake)
    count = count + 1
    time.sleep(0.5)
