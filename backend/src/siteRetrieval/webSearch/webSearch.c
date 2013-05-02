/*****************************************************************************/
/* PROGRAM:       webSearch.c                                                */
/* DESCRIPTION:                                                              */
/* This program utilized the Google Custom Search API                        */
/* to retrieve search results for the passed in criteria.                    */
/*                                                                           */
/*                                                                           */
/* DATE WRITTEN:  05/29/2012                                                 */
/* AUTHOR:        Marvin Carlisle                                            */
/*                                                                           */
/*****************************************************************************/
/*                                                                           */
/* DATE CHG     PGMR    REQUEST#    PURPOSE                                  */
/* --------     ----    --------    -------                                  */
/*                                                                           */
/*****************************************************************************/
/*                                                                           */
/* COMPILE COMMAND:                                                          */
/*                                                                           */
/*****************************************************************************/
/* RUN COMMAND:                                                              */
/* webSearch <search_string_file>                                            */
/*                                                                           */
/*****************************************************************************/


/************/
/* Includes */
/************/
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <openssl/rand.h>
#include <openssl/ssl.h>
#include <openssl/err.h>


/***********/
/* Defines */
/***********/
#define SERVER  "www.googleapis.com"
#define PORT    443
#define NUM_QUERIES 1


/***********/
/* Globals */
/***********/
FILE* pResults = NULL;


/*************************************/
/* Simple structure to keep track of */
/* the handle, context, and socket   */
/*************************************/
typedef struct {
     int socket;
     SSL *sslHandle;
     SSL_CTX *sslContext;
} connection;


/***********************/
/* Function Prototypes */
/***********************/
int tcpConnect(void);
connection *sslConnect(void);
void sslDisconnect(connection *c);
void sslRead(connection *c);
void sslWrite(connection *c, char *text);


/******************************************************************************/
/* FUNCTION: main                                                             */
/*                                                                            */
/* PARAMETERS:                                                                */
/*    argc (integer)                                                          */
/*    argv (char array pointer, the parameters for the function               */
/* RETURN VALUE:                                                              */
/*    retval: N/A                                                             */
/******************************************************************************/
int main (int argc, char **argv)
{
   int i;
   connection *c;
   char request[1024]="";
   char key[1024]="";
   char terms[1024]="";
   char filename[128]="";
   FILE* pSearchTerms = NULL;

   /*****************************************/
   /* Open the search term file for reading */
   /*****************************************/
   sprintf(filename, "./%s", argv[1]);
   pSearchTerms = fopen(filename, "r");

   if(pSearchTerms == NULL)
   {
      fprintf(stderr, "Error opening search terms file %s!\n", filename);
      return (EXIT_FAILURE);
   }

   /***************************************/
   /* Open the results file for appending */
   /***************************************/
   sprintf(filename, "./%s.res", argv[1]);
   pResults = fopen(filename, "w+");

   if(pResults == NULL)
   {
      fprintf(stderr, "Error opening results file %s!\n", filename);
      return (EXIT_FAILURE);
   }

   /***********************************/
   /* Read from the search terms file */
   /***********************************/
   fgets(terms, 1024, pSearchTerms);
   terms[strlen(terms)-1] = '\0';

   /**************************/
   /* Get our search results */
   /**************************/
   for(i = 0; i < NUM_QUERIES; i++)
   {
      c = sslConnect ();
      sprintf(key, "/customsearch/v1?key=GOOGLE_API_SECRET&cx=003397780648636422832:u25rx3s92ro&fields=items(link)&start=%d&q=%s", ((i* 10) + 1), terms);
      sprintf(request, "GET https://%s%s\r\n\r\n", SERVER, key);
      fprintf(stdout, "%s", request);
      sslWrite(c, request);
      sslRead(c);
      sslDisconnect (c);
   }

   /***************************/
   /* Close the file pointers */
   /***************************/
   fclose(pSearchTerms);
   fclose(pResults);

   /************************/
   /* Call the JSON parser */
   /************************/

   /*****************************************/
   /* Call the Text Processor and Retriever */
   /*****************************************/

   /****************************/
   /* Call the Site Classifier */
   /****************************/

   return (EXIT_SUCCESS);
}


/******************************************************************************/
/* FUNCTION: tcpConnect                                                       */
/*                                                                            */
/* DESCRIPTION: Establish a regular TCP connection                            */
/*                                                                            */
/* PARAMETERS:                                                                */
/*                                                                            */
/* RETURN VALUE:                                                              */
/*    Socket file descriptor (integer)                                        */
/******************************************************************************/
int tcpConnect (void)
{
   int error, sockfd;
   struct hostent *host;
   struct sockaddr_in server;

   host = gethostbyname (SERVER);
   sockfd = socket (AF_INET, SOCK_STREAM, 0);
   if (sockfd == -1)
   {
      perror ("Socket");
      sockfd = 0;
   }
   else
   {
      server.sin_family = AF_INET;
      server.sin_port = htons (PORT);
      server.sin_addr = *((struct in_addr *) host->h_addr);
      bzero (&(server.sin_zero), 8);

      error = connect (sockfd, (struct sockaddr *) &server,
                        sizeof (struct sockaddr));
      if (error == -1)
      {
         perror ("Connect");
         sockfd = 0;
      }
   }

   return sockfd;
}


/******************************************************************************/
/* FUNCTION: sslConnect                                                       */
/*                                                                            */
/* DESCRIPTION: Establish a connect using an SSL layer                        */
/*                                                                            */
/* PARAMETERS:                                                                */
/*                                                                            */
/* RETURN VALUE:                                                              */
/*    connection structure (connection)                                       */
/******************************************************************************/
connection *sslConnect (void)
{
   connection *c;

   c = malloc (sizeof (connection));
   c->sslHandle = NULL;
   c->sslContext = NULL;

   c->socket = tcpConnect ();
   if (c->socket)
     {
       // Register the error strings for libcrypto & libssl
       SSL_load_error_strings ();

       // Register the available ciphers and digests
       SSL_library_init ();

       // New context saying we are a client, and using SSL 2 or 3
       c->sslContext = SSL_CTX_new (SSLv23_client_method ());
       if (c->sslContext == NULL)
       {
         ERR_print_errors_fp (stderr);
       }

       // Create an SSL struct for the connection
       c->sslHandle = SSL_new (c->sslContext);
       if (c->sslHandle == NULL)
       {
         ERR_print_errors_fp (stderr);
       }

       // Connect the SSL struct to our connection
       if (!SSL_set_fd (c->sslHandle, c->socket))
       {
         ERR_print_errors_fp (stderr);
       }

       // Initiate SSL handshake
       if (SSL_connect (c->sslHandle) != 1)
       {
         ERR_print_errors_fp (stderr);
       }
     }
   else
     {
       perror ("Connect failed");
     }

   return c;
}


/******************************************************************************/
/* FUNCTION: sslDisconnect                                                    */
/*                                                                            */
/* DESCRIPTION: Disconnect and free connection struct                         */
/*                                                                            */
/* PARAMETERS:                                                                */
/*    c - connection struct to free up (connection)                           */
/* RETURN VALUE:                                                              */
/*    connection structure (connection)                                       */
/******************************************************************************/
void sslDisconnect (connection *c)
{
   if (c->socket)
   {
     close (c->socket);
   }

   if (c->sslHandle)
   {
      SSL_shutdown (c->sslHandle);
      SSL_free (c->sslHandle);
   }
   if (c->sslContext)
   {
     SSL_CTX_free (c->sslContext);
   }

   free (c);
}


/******************************************************************************/
/* FUNCTION: sslRead                                                          */
/*                                                                            */
/* DESCRIPTION: Read all available text from the connection                   */
/*                                                                            */
/* PARAMETERS:                                                                */
/*    c - connection struct to free up (connection)                           */
/* RETURN VALUE:                                                              */
/*                                                                            */
/******************************************************************************/
void sslRead (connection *c)
{
   const int readSize = 2048;
   char *rc = NULL;
   int received, count = 0, firstTime = 0;
   char buffer[2048] = "";

   if (c)
   {
      while (1)
      {
         if (!rc)
         {
            rc = malloc (readSize * sizeof (char) + 1);
         }
         else
         {
            rc = realloc (rc, (count + 1) * readSize * sizeof (char) + 1);
         }

         received = SSL_read (c->sslHandle, buffer, readSize);
         buffer[received] = '\0';

         /**********************************/
         /* Ignore the first block of data */
         /**********************************/
         if (firstTime == 0)
         {
            firstTime = 1;
            continue;
         }

         if (received > 0)
         {
            strcat (rc, buffer);
         }
         else
         {
           /****************************************/
           /* The first six characters are garbage */
           /****************************************/
           rc += 6;

           fprintf(pResults, "%s", rc);
           break;
         } 

         count++;
      }
   }
}


/******************************************************************************/
/* FUNCTION: sslWrite                                                         */
/*                                                                            */
/* DESCRIPTION: Write text to the connecteion                                 */
/*                                                                            */
/* PARAMETERS:                                                                */
/*    c - connection struct to free up (connection pointer)                   */
/*    text - text to be written to the connection (character pointer)         */
/* RETURN VALUE:                                                              */
/*                                                                            */
/******************************************************************************/
void sslWrite (connection *c, char *text)
{
   if (c)
   {
      SSL_write (c->sslHandle, text, strlen (text));
   }
}
