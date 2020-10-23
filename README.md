# FreeBuds 3 Exploit

Inspired by [CVE-2020-15808](https://twitter.com/horac341/status/1311911734572208129), this project is used to get code execution of [FreeBuds](https://consumer.huawei.com/en/audio/freebuds3/)'s charging case. 



### About FreeBuds 3

Very similar to Apple's AirPods, FreeBuds is a combinations of a pair of headsets and a charing case.

The charing case is built based on STM32 chip.
The headset is built base on Kirin A1 (with very similar memory layout of STM devices).
The USB of charing case enables CDC connection for AT Commands, which implies the vulnerability.

Download its 1.0.0.578 firmware from [link](http://update.dbankcdn.com/TDS/data/files/p14/s162/G5486/g5485/v453532/f1//full/update_cota_para.zip
).



### About The Exploit

The original vulnerability is used to leak a buffer from the target device.

However, another code branch inside `USBD_CDC_Setup` allows us to write data back to the same buffer.
The buffer is part of `USBD_CDC_HandleTypeDef` structure, a member called `data` to be exactly.

```c
typedef struct
{
    uint32_t data[128];
    uint8_t  CmdOpCode;
    uint8_t  CmdLength;
    uint32_t RxBuffer;
    uint32_t TxBuffer;
    uint32_t RxLength;
    uint32_t TxLength;
    uint32_t TxState;
    uint32_t RxState;
    uint32_t Addr;
} USBD_CDC_HandleTypeDef;
```
Since there is no length verfication, OOB read/write of `USBD_CDC_HandleTypeDef.data` leads to full data control of struct `USBD_CDC_HandleTypeDef`.

In that case, we could write controlled data to any addresses by simply altering `RxBuffer` and bulk write the content.
I simply utilize this write primitive to modify USBD_FS_ManufacturerStrDescriptor, pointing to our shellcode.
After that, fetching the manufacture string triggers the shellcode execution.

Check the manufacture string to verify the code execution.
```sh
lsusb -v -d 0483:5740
```


### About libusb

As the original libusb limits the buffer size to be 0x1000, libusb-1.0.a attached removes the limitation.



