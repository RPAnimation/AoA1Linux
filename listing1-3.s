# listing 1-3:
# A simple Gas module that contains an empty function to be 
# called by the C++ code in listing 1-2.

            .text
            .global asmFunc
        
        
# Here is the "asmFunc" function.

asmFunc:

# Empty function just returns to C++ code
        
        ret     #returns to caller


