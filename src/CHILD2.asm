**********************************************************************
* Licensed Materials - Property of IBM                               *
*                                                                    *
* SAMPLE                                                             *
*                                                                    *
* (c) Copyright IBM Corp. 2016 All Rights Reserved                   *       
*                                                                    *
* US Government Users Restricted Rights - Use, duplication or        *
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp   *
*                                                                    *
*                                                                    *
**********************************************************************
*ASM     XOPTS(CICS,SP)                                               
DFHEISTG DSECT                                                        
FLEN     DS    F                                                      
CONTAREA DS    CL30                                                   
*                                                                     
**********************************************************************
***                                                                ***
***      Program CHILD2 is the application for transaction CHL2    ***
***                                                                ***
***      This program GETs the request container passed by the     ***
***      parent transaction. The contents are validated. If the    ***
***      request container contains the expected content, a        ***
***      response container is written onto the channel.           ***
***                                                                ***
***      The response container will be 'FETCHed' by the parent.   ***
***                                                                ***
***      If there is no request container or the request container ***
***      contains invalid content, we abend with abend code BADC.  ***
***                                                                ***
**********************************************************************
CHILD2   CSECT                                                          
CHILD2   AMODE 31                                                       
CHILD2   RMODE ANY                                                      
         MVC   FLEN,=F'30'                                              
         EXEC CICS GET CONTAINER('REQUEST') INTO(CONTAREA)             X
               FLENGTH(FLEN) NOHANDLE                                   
         CLC   EIBRESP,DFHRESP(NORMAL)                                  
         BNE   ABEND                                                    
         CLC   CONTAREA,REQ2                                            
         BNE   ABEND                                                    
         EXEC CICS PUT CONTAINER('RESPONSE') FROM(RESP)                 
RETURN   DS    0H                                                       
         EXEC CICS RETURN                                               
ABEND    DS    0H                                                       
         EXEC CICS ABEND ABCODE('BADC')                                 
REQ2     DC    CL30'PARENT REQUEST FOR CHILD2'                          
RESP     DC    CL79'NORMAL RESPONSE FROM CHL2'                          
         END   CHILD2                                                   
