#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'RadioSenseMsg'
# message type.
#

import tinyos.message.Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 6

# The Active Message type associated with this message.
AM_TYPE = 7

class RadioSenseMsg(tinyos.message.Message.Message):
    # Create a new RadioSenseMsg of size 6.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=6):
        tinyos.message.Message.Message.__init__(self, data, addr, gid, base_offset, data_length)
        self.amTypeSet(AM_TYPE)
    
    # Get AM_TYPE
    def get_amType(cls):
        return AM_TYPE
    
    get_amType = classmethod(get_amType)
    
    #
    # Return a String representation of this message. Includes the
    # message type name and the non-indexed field values.
    #
    def __str__(self):
        s = "Message <RadioSenseMsg> \n"
        try:
            s += "  [id=0x%x]\n" % (self.get_id())
        except:
            pass
        try:
            s += "  [temp=0x%x]\n" % (self.get_temp())
        except:
            pass
        try:
            s += "  [humi=0x%x]\n" % (self.get_humi())
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: id
    #   Field type: int
    #   Offset (bits): 0
    #   Size (bits): 16
    #

    #
    # Return whether the field 'id' is signed (False).
    #
    def isSigned_id(self):
        return False
    
    #
    # Return whether the field 'id' is an array (False).
    #
    def isArray_id(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'id'
    #
    def offset_id(self):
        return (0 / 8)
    
    #
    # Return the offset (in bits) of the field 'id'
    #
    def offsetBits_id(self):
        return 0
    
    #
    # Return the value (as a int) of the field 'id'
    #
    def get_id(self):
        return self.getUIntElement(self.offsetBits_id(), 16, 1)
    
    #
    # Set the value of the field 'id'
    #
    def set_id(self, value):
        self.setUIntElement(self.offsetBits_id(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'id'
    #
    def size_id(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'id'
    #
    def sizeBits_id(self):
        return 16
    
    #
    # Accessor methods for field: temp
    #   Field type: int
    #   Offset (bits): 16
    #   Size (bits): 16
    #

    #
    # Return whether the field 'temp' is signed (False).
    #
    def isSigned_temp(self):
        return False
    
    #
    # Return whether the field 'temp' is an array (False).
    #
    def isArray_temp(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'temp'
    #
    def offset_temp(self):
        return (16 / 8)
    
    #
    # Return the offset (in bits) of the field 'temp'
    #
    def offsetBits_temp(self):
        return 16
    
    #
    # Return the value (as a int) of the field 'temp'
    #
    def get_temp(self):
        return self.getUIntElement(self.offsetBits_temp(), 16, 1)
    
    #
    # Set the value of the field 'temp'
    #
    def set_temp(self, value):
        self.setUIntElement(self.offsetBits_temp(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'temp'
    #
    def size_temp(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'temp'
    #
    def sizeBits_temp(self):
        return 16
    
    #
    # Accessor methods for field: humi
    #   Field type: int
    #   Offset (bits): 32
    #   Size (bits): 16
    #

    #
    # Return whether the field 'humi' is signed (False).
    #
    def isSigned_humi(self):
        return False
    
    #
    # Return whether the field 'humi' is an array (False).
    #
    def isArray_humi(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'humi'
    #
    def offset_humi(self):
        return (32 / 8)
    
    #
    # Return the offset (in bits) of the field 'humi'
    #
    def offsetBits_humi(self):
        return 32
    
    #
    # Return the value (as a int) of the field 'humi'
    #
    def get_humi(self):
        return self.getUIntElement(self.offsetBits_humi(), 16, 1)
    
    #
    # Set the value of the field 'humi'
    #
    def set_humi(self, value):
        self.setUIntElement(self.offsetBits_humi(), 16, value, 1)
    
    #
    # Return the size, in bytes, of the field 'humi'
    #
    def size_humi(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'humi'
    #
    def sizeBits_humi(self):
        return 16
    
