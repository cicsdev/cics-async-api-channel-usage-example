# CICS asynchronous API channel usage example

This is a basic example of channel usage with the ASYNC API coded in assembler.

## Overview

The project consists of five transactions/programs. There is a single parent transaction 
and four child transactions (started by the parent).

The parent passes various channel types to the children. One is an 'unknown' 
channel. Each channel is populated with an appropriate  request container (apart from the 
'unknown' channel).

Each child reads the request container passed to it. It validates the content of the 
container. If the request is valid, the child will add a response container to the 
channel before completing
 
If a child cannot find the request container it is expecting, it abends - with abend code 
'BADC'.

The parent task fetches the completion state and response channel from each child in
turn. 

The parent generates a line of output for the response from each child. In the example,
the first 3 chldren complete normally and the 4th child abends with code 'BADC'.

This application is deigned to run as a 3270 terminal application with a screen width of 80.
It can also execute as a 3270 web-bridge application.


## Example

Assuming the following CSD definitions have been installed in CICS :

    DEFINE TRANSACTION(PRNT) GROUP(AS) PROGRAM(PARENT)
    DEFINE PROGRAM(PARENT)   GROUP(AS) 

    DEFINE TRANSACTION(CHL1) GROUP(AS) PROGRAM(CHILD1)
    DEFINE PROGRAM(CHILD1)   GROUP(AS) 
    
    DEFINE TRANSACTION(CHL2) GROUP(AS) PROGRAM(CHILD2)
    DEFINE PROGRAM(CHILD2)   GROUP(AS) 

    DEFINE TRANSACTION(CHL3) GROUP(AS) PROGRAM(CHILD3)
    DEFINE PROGRAM(CHILD3)   GROUP(AS) 

    DEFINE TRANSACTION(CHL4) GROUP(AS) PROGRAM(CHILD4)
    DEFINE PROGRAM(CHILD4)   GROUP(AS) 


The parent program is invoked with transaction `PRNT` from a 3270 terminal with a 
screen width of 80. Alternatively PRNT can be run from a browser using the 3270 
web bridge function. 

The screen output will appear thus :-

	RESPONSES RECEIVED FROM CHILDREN               
	--------------------------------               
                                               
	NORMAL RESPONSE FROM CHL1                      
	NORMAL RESPONSE FROM CHL2                      
	NORMAL RESPONSE FROM CHL3                      
	TRANSACTION CHL4 ABENDED - ABEND CODE BADC     

## License

This project is licensed under [Apache License Version 2.0](LICENSE).  
 





