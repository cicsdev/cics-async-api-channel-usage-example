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
***      Program CHILD4 is the application for transaction CHL4    ***
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
CHILD4   CSECT                                                          
CHILD4   AMODE 31                                                       
CHILD4   RMODE ANY                                                      
         MVC   FLEN,=F'30'                                              
         EXEC CICS GET CONTAINER('REQUEST') INTO(CONTAREA)             X
               FLENGTH(FLEN) NOHANDLE                                   
         CLC   EIBRESP,DFHRESP(NORMAL)                                  
         BNE   ABEND                                                    
         CLC   CONTAREA,REQ4                                            
         BNE   ABEND                                                    
         EXEC CICS PUT CONTAINER('RESPONSE') FROM(RESP)                 
RETURN   DS    0H                                                       
         EXEC CICS RETURN                                               
ABEND    DS    0H                                                       
         EXEC CICS ABEND ABCODE('BADC')                                 
REQ4     DC    CL30'PARENT REQUEST FOR CHILD4'                          
RESP     DC    CL79'NORMAL RESPONSE FROM CHL4'                          
         END   CHILD4                                                   