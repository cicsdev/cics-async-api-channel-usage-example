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
PT       DSECT                              
DFHEISTG DSECT                              
CHL1TOK  DS     CL16                        
CHL2TOK  DS     CL16                        
CHL3TOK  DS     CL16                        
CHL4TOK  DS     CL16                        
CHL1RESPCHAN DS     CL16                    
CHL2RESPCHAN DS     CL16                    
CHL3RESPCHAN DS     CL16                    
CHL4RESPCHAN DS     CL16                    
ABCODE   DS     CL4                         
COMPSTAT DS     CL4                         
FLEN     DS     F                          
CONTAREA DS     CL30                        
SCREEN   DS     0D                          
SCREENH1 DS     CL79                        
SCREENH2 DS     CL79                                                   
SCREENH3 DS     CL79                                                   
SCREEN1  DS     CL79                                                   
SCREEN2  DS     CL79                                                   
SCREEN3  DS     CL79                                                   
SCREEN4  DS     CL79                                                   
SCREENL  EQU    *-SCREEN                                               
PARENT   CSECT                                                         
PARENT   AMODE 31                                                      
PARENT   RMODE ANY                                                     
********************************************************************** 
***      The following code creates 4 children passing various     *** 
***      containers.                                               *** 
***                                                                *** 
***      The parent needs to reserve storage to hold               *** 
***      4 child tokens (CHL1TOK, CHL2TOK, CHL3TOK, CHL4TOK).      *** 
***      These tokens are used on both EXEC CICS RUN TRANSID and   *** 
***      THE EXEC CICS FETCH command(s).                           *** 
***                                                                *** 
***      The parent needs to reserve storage to hold the names of  *** 
***      4 response channels - one for each child ( CHL1RESPCHAN,  ***  
***      CHL2RESPCHAN, CHL3RESPCHAN, CHL3RESPCHAN).                ***  
***      These are used on the EXEC CICS FETCH command(s).         ***  
***                                                                ***  
***      Child CHL1 is passed program channel 'CHL1-CHANNEL'. This ***  
***      contains a single container called 'REQUEST'.             ***  
***                                                                ***  
***      Child CHL2 is passed program channel 'CHL2-CHANNEL'. This ***  
***      contains a single container called 'REQUEST'.             ***  
***                                                                ***  
***      Child CHL3 is passed transaction channel 'DFHTRANSACTION'.***  
***      This contains a single container called 'REQUEST'.        ***  
***                                                                ***  
***      Child CHL4 is passed an 'UNKNOWN' channel. CICS will      ***  
***      create an empty channel called 'UNKNOWN' and pass this    ***  
***      to CHL4.                                                  ***  
**********************************************************************  
RUNCHL1  DS    0H                                                       
         EXEC CICS PUT CONTAINER('REQUEST') FROM(REQ1)                 X
               CHANNEL('CHL1-CHANNEL')                                  
         EXEC CICS RUN TRANSID('CHL1')              CHILD(CHL1TOK)     X 
               CHANNEL('CHL1-CHANNEL')                                   
RUNCHL2  DS    0H                                                        
         EXEC CICS PUT CONTAINER('REQUEST') FROM(REQ2)                 X 
               CHANNEL('CHL2-CHANNEL')                                   
         EXEC CICS RUN TRANSID('CHL2')              CHILD(CHL2TOK)     X 
               CHANNEL('CHL2-CHANNEL')                                   
RUNCHL3  DS    0H                                                        
         EXEC CICS PUT CONTAINER('REQUEST') FROM(REQ3)                 X 
               CHANNEL('DFHTRANSACTION')                                 
         EXEC CICS RUN TRANSID('CHL3')              CHILD(CHL3TOK)     X 
               CHANNEL('DFHTRANSACTION')                                 
RUNCHL4  DS    0H                                                        
         EXEC CICS RUN TRANSID('CHL4')              CHILD(CHL4TOK)     X 
               CHANNEL('UNKNOWN') NOHANDLE                               
FETCH1   DS    0H                                                        
         EXEC CICS FETCH CHILD(CHL1TOK) CHANNEL(CHL1RESPCHAN)          X 
               COMPSTATUS(COMPSTAT) ABCODE(ABCODE)                       
         CLC   COMPSTAT,DFHVALUE(NORMAL)                                 
         BNE   CHL1ABND                                                  
         MVC   FLEN,=F'79'                                               
         EXEC CICS GET CONTAINER('RESPONSE') CHANNEL(CHL1RESPCHAN)     X 
               INTO(SCREEN1) FLENGTH(FLEN)                               
         B     FETCH2                                                    
CHL1ABND DS    0H                                                        
         MVC   SCREEN1,=CL79'TRANSACTION CHL1 ABENDED - ABEND CODE '     
         MVC   SCREEN1+38(4),ABCODE                                      
FETCH2   DS    0H                                                        
         EXEC CICS FETCH CHILD(CHL2TOK) CHANNEL(CHL2RESPCHAN)          X 
               COMPSTATUS(COMPSTAT) ABCODE(ABCODE)                       
         CLC   COMPSTAT,DFHVALUE(NORMAL)                                 
         BNE   CHL2ABND                                                  
         MVC   FLEN,=F'79'                                               
         EXEC CICS GET CONTAINER('RESPONSE') CHANNEL(CHL2RESPCHAN)     X 
               INTO(SCREEN2) FLENGTH(FLEN)                               
         B     FETCH3                                                    
CHL2ABND DS    0H                                                        
         MVC   SCREEN2,=CL79'TRANSACTION CHL2 ABENDED - ABEND CODE '     
         MVC   SCREEN2+38(4),ABCODE                                      
FETCH3   DS    0H                                                        
         EXEC CICS FETCH CHILD(CHL3TOK) CHANNEL(CHL3RESPCHAN)          X
               COMPSTATUS(COMPSTAT) ABCODE(ABCODE)                      
         CLC   COMPSTAT,DFHVALUE(NORMAL)                                
         BNE   CHL3ABND                                                 
         MVC   FLEN,=F'79'                                              
         EXEC CICS GET CONTAINER('RESPONSE') CHANNEL(CHL3RESPCHAN)     X
               INTO(SCREEN3) FLENGTH(FLEN)                              
         B     FETCH4                                                   
CHL3ABND DS    0H                                                       
         MVC   SCREEN3,=CL79'TRANSACTION CHL3 ABENDED - ABEND CODE '    
         MVC   SCREEN3+38(4),ABCODE                                     
FETCH4   DS    0H                                                       
         EXEC CICS FETCH CHILD(CHL4TOK) CHANNEL(CHL4RESPCHAN)          X
               COMPSTATUS(COMPSTAT) ABCODE(ABCODE)                      
         CLC   COMPSTAT,DFHVALUE(NORMAL)                                
         BNE   CHL4ABND                                                 
         MVC   FLEN,=F'79'                                              
         EXEC CICS GET CONTAINER('RESPONSE') CHANNEL(CHL4RESPCHAN)     X
               INTO(SCREEN4) FLENGTH(FLEN)                              
         B     ALLDONE                                                  
CHL4ABND DS    0H                                                       
         MVC   SCREEN4,=CL79'TRANSACTION CHL4 ABENDED - ABEND CODE '    
         MVC   SCREEN4+38(4),ABCODE                                     
ALLDONE  DS    0H                                                       
         MVC   SCREENH1,=CL79'RESPONSES RECEIVED FROM CHILDREN'         
         MVC   SCREENH2,=CL79'--------------------------------'         
         MVC   SCREENH3,=CL79' '                                        
         EXEC CICS SEND TEXT FROM(SCREEN) LENGTH(=AL2(SCREENL)) ERASE  X
               FREEKB                                                   
         EXEC CICS RETURN                                               
REQ1     DC    CL30'PARENT REQUEST FOR CHILD1'                          
REQ2     DC    CL30'PARENT REQUEST FOR CHILD2'                          
REQ3     DC    CL30'PARENT REQUEST FOR CHILD3'                          
         END                                                            
