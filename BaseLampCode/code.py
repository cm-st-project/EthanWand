import board
import neopixel
import time
import random
import adafruit_rfm69
import digitalio

import busio
spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)


print("BLE Setup Start")
from adafruit_ble import BLERadio
from adafruit_ble.advertising.standard import ProvideServicesAdvertisement
from adafruit_ble.services.nordic import UARTService

ble = BLERadio()
ble.name = "GoldenSnitch"
print(ble.name)
uart = UARTService()
advertisement = ProvideServicesAdvertisement(uart)

print(uart)
print(advertisement)

print("BLE Setup Done")



# Define radio frequency in MHz. Must match your
# module. Can be a value like 915.0, 433.0, etc.
print("rfm69 setup start")
RADIO_FREQ_MHZ = 915.0

# Define Chip Select and Reset pins for the radio module.
CS = digitalio.DigitalInOut(board.D5)
RESET = digitalio.DigitalInOut(board.D6)

# Initialise RFM69 radio
rfm69 = adafruit_rfm69.RFM69(spi, CS, RESET, RADIO_FREQ_MHZ)

print("rfm69 setup complete")
# Set up the NeoPixel Strip
pixel_pin = board.D10  # Set up the data cable to the numbered port. According to the pinout sheet.
num_pixels = 24  # The maximum pixels (lights) is 30

# Initialize the neopixel object
ORDER = neopixel.RGBW
pixels = neopixel.NeoPixel(pixel_pin, num_pixels, brightness=1, auto_write=False, bpp = 4, pixel_order=ORDER)

def color(r, g, b, w = 0):
    return (r, g, b, w)

def spotlight(wait=0.1):
    a = [19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29]  # Updated the range for 30 pixels
    b = [24, 25, 26, 27, 28, 29]  # Updated the range for 30 pixels
    for i in range(num_pixels):
        rand_color = (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255), 0)
        for index in a:
            pixels[index] = rand_color
        pixels.show()
        time.sleep(wait)

        rand_color = (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
        for index in b:
            pixels[index] = rand_color
        pixels.show()
        time.sleep(wait)

# Alternate color wipe: fill every other pixel with a color
def alternate_color_wipe(color, wait):
    for i in range(0, num_pixels, 2):
        pixels[i] = color
        pixels.show()
        time.sleep(wait)
    time.sleep(0.8)

# Simple function to display color
def show_color(color, wait):
    pixels.fill(color)  # set all pixels to specified color
    pixels.show()  # update the LED strip to display color
    time.sleep(wait)

def changing_colors(wait=0.01):
    for i in range(0, num_pixels, 1):
        rand_color = (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
        pixels[i] = rand_color
        pixels.show()
        time.sleep(wait)

def wheel(pos):
    if pos < 85:
        return (255 - pos * 3, pos * 3, 0)
    elif pos < 170:
        pos -= 85
        return (0, 255 - pos * 3, pos * 3)
    else:
        pos -= 170
        return (pos * 3, 0, 255 - pos * 3)

def color_wave(wait):
    for j in range(255):  # go through all the colors
        #print(j)
        for i in range(num_pixels):
            pixel_index = (i * 256 // num_pixels) + j
            pixels[i] = wheel(pixel_index & 255)
        pixels.show()
        time.sleep(wait)



pixels.fill((0, 0, 0))
pixels.show()


def radioMode():
    print("radiomode")
    # Look for a new packet - wait up to 5 seconds:
    packet = rfm69.receive(timeout=1.0)
    # If no packet was received during the timeout then None is returned.
    if packet is not None:
        print("Received a packet!", packet)
        # If the received packet is b'button'...
        if packet == b'up':
            pixels.fill((0, 255, 0))
        elif packet == b'left':
            pixels.fill((255, 0, 0))
        elif packet == b'right':
            pixels.fill((0, 0, 255))
        elif packet == b'down':
            pixels.fill((0, 0, 0))
        elif packet == b'shake':
            pixels.fill((0, 255, 255))

        pixels.show()

def bleMode():
    #print("bleMode")
    byte = uart.read(1)
    if byte is not None:
        if byte != b'':
            print("Received a packet!", byte)

        # If the received packet is b'button'...
        if byte == b'a':
            pixels.fill((0, 255, 0))
        elif byte == b'b':
            pixels.fill((255, 0, 0))
        elif byte == b'c':
            pixels.fill((0, 0, 255))
        elif byte == b'd':
            pixels.fill((0, 0, 0))
        elif byte == b'e':
            pixels.fill((0, 255, 255))

        pixels.show()



is_advertising = False
while True:
    # BLE not connected do the radio stuff
    if not ble.connected:
        if not is_advertising:
            is_advertising = True
            ble.start_advertising(advertisement)
        radioMode()

    elif ble.connected:
        is_advertising = False
        #print(advertisement)
        bleMode()


## Just the radio

while True:
    # Look for a new packet - wait up to 5 seconds:
    packet = rfm69.receive(timeout=5.0)
    # If no packet was received during the timeout then None is returned.
    if packet is not None:
        print("Received a packet!", packet)
        # If the received packet is b'button'...
        if packet == b'up':
            pixels.fill((0, 255, 0))
        elif packet == b'left':
            pixels.fill((255, 0, 0))
        elif packet == b'right':
            pixels.fill((0, 0, 255))
        elif packet == b'down':
            pixels.fill((0, 0, 0))
        elif packet == b'shake':
            pixels.fill((0, 255, 255))

        pixels.show()

while True:
    # changing_colors()
    color_wave(0.05)
    print("wave")


    #spotlight()

    '''
    # show_color(color(237, 200, 12),2)
    alternate_color_wipe(color(255, 0, 0), 0.1)
    alternate_color_wipe(color(0, 255, 0), 0.1)
    alternate_color_wipe(color(0, 0, 255), 0.1)
    alternate_color_wipe(color(255, 255, 255), 0.1)
    '''

