# Image-Processing-Chain-Code-FPGA

### General description of the project

In this project, we implemented one of the image coding algorithms, in a way that in several steps, we coded an image, calculated its perimeter and area, sent it to the Decode unit using the UART protocol, and re-encoded the original image. To implement this goal, we use the Chain Code algorithm; For a better and more accurate implementation of the algorithm, we use the eight-directional version of this algorithm, the direction of which will be as follows, with the prioritization applied, in the order of zero to seven. It should be noted that in order to establish a connection between Encoder and Decoder modules using the UART protocol, we need two modules, one of which should be configured as a Transmitter and the other as a Receiver; In the first UART, data is read in parallel and transferred serially to the second UART, which due to the many limitations we create for our implementation, we are forced to use different clks, which are explained in detail below.

<img width="270" alt="Screenshot 2024-02-16 at 10 51 58 PM" src="https://github.com/arsalanjabbari/Image-Processing-Chain-Code-FPGA/assets/93816830/badb04ea-4e18-46e9-9d99-2a56dbc9d655">


### Analysis of project implementation method and phases

In the image below, we have analyzed and drawn the project solution method in detail, the project implementation flow can be tracked, and our assumptions can be seen during implementation, navigation, data transmission, connection and analysis of modules:

<img width="602" alt="Screenshot 2024-02-16 at 10 54 05 PM" src="https://github.com/arsalanjabbari/Image-Processing-Chain-Code-FPGA/assets/93816830/66a43661-0448-48f2-9b68-4d8f77daaad4">


## Phase Zero (Python Converter)

In the zero phase of the project, we have the task of converting the 64 x 64 bit image that is zero (white) and one (black) into the desired format with the help of Python to be imported into the IP Core made of RAM. In the project modules we are converting; that this format coe. LT is. Also, for this, we have the task of converting the photo into a bit string, which we do with the help of the image_to_array function.

## First phase (Encoder Module)

We consider several states for this part. The first state is init. In this state, we consider the initial value for our variables and also the desired image, which is zero and one, inside a two-dimensional array in this module from ip core. we take
In the idle state, we have started, we enter the find start state, and in this state, we find the starting point using two loops, so that we move on the array, and the first one becomes our start point. Next, we enter the calculate chain state. We find the desired path of the desired chain code and also add one to the perimeter value each time and store this code in an array. Next, we enter the next state, where we check whether we have reached the start point or not. If we have reached it, we will enter the area calculation state, where to calculate the area, we move with two variables, one on the line and one on the length, and when we reach one, we add one to the area.
Finally, we have the status of sending values, in which we send the generated code byte byte.

## Second phase (UART Transmitter)

In this part, we have a UART transmitter, which is basically an eight-bit shift register, we consider that at first we send a zero bit as a start bit through the serial base, and then by shifting the 8-bit data in question, we send the data through We connect the serial line to the receiver's UART and finally send a stop bit to show that our one-byte data is over.


## Third phase (UART Receiver)

In this part, we have a UART receiver, which is again a shift register that enters our 8-bit data bit by bit, and after the stop bit arrives, we let the decoder know that our one-byte data is ready with the ready signal.

## Fourth phase (Decoder Module)

In this part, we are dealing with the reverse operation of Encoder, in which we need to advance from the 6 states that we considered, one of the important states of this section is filling the inner area of the shape, which is done using the algorithm implemented in the code. . We still make sure that the decoded form is correct by checking the environment. It should be noted that the algorithm paints the task of coloring four times and completely up to the edge of the figure to make sure that there is no unpainted part of the image.
