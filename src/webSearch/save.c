#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <errno.h>

#include <openssl/rand.h>
#include <openssl/ssl.h>
#include <openssl/err.h>

typedef struct {
    int socket;
    SSL *sslHandle;
    SSL_CTX *sslContext;
} connection;


int main(int argc, char** argv) 
{

   int i;
   int port = 80;
   char arg[500]="";
   char firstHalf[500]="";
   char secondHalf[500]="";
   char request[1000]="";
   struct hostent *server;
   struct sockaddr_in serveraddr;


   connection* c;

   c = sslConnewct()

   

   strcpy(arg, argv[1]);

   for (i = 0; i < strlen(arg); i++)
   {
      if (arg[i] == '/')
      {
         strncpy(firstHalf, arg, i);
         firstHalf[i] = '\0';
         break;
      }
   }

   for (i; i < strlen(arg); i++)
   {
      strcat(secondHalf, &arg[i]);
      break;
   }

   strcpy(secondHalf, arg+i);
   printf("\nFirst Half: %s", firstHalf);

   printf("\nSecond Half: %s", secondHalf);

   int tcpSocket = socket(AF_INET, SOCK_STREAM, 0);

   if (tcpSocket < 0)
      printf("\nError opening socket");
   else
      printf("\nSuccessfully opened socket");

   server = gethostbyname(firstHalf);

   if (server == NULL)
   {
      printf("gethostbyname() failed\n");
   }
   else
   {
      printf("\n%s = ", server->h_name);
      fflush(stdout);

      unsigned int j = 0;
      while (server -> h_addr_list[j] != NULL)
      {
         printf("%s", inet_ntoa(*(struct in_addr*)(server -> h_addr_list[j])));
         fflush(stdout);
         j++;
      }
   }

   printf("\n");

   bzero((char *) &serveraddr, sizeof(serveraddr));
   serveraddr.sin_family = AF_INET;

   bcopy((char *)server->h_addr, (char *)&serveraddr.sin_addr.s_addr, server->h_length);

   serveraddr.sin_port = htons(port);

   printf("\nConnecting ...");
   if (connect(tcpSocket, (struct sockaddr *) &serveraddr, sizeof(serveraddr)) < 0)
      printf("\nError Connecting");
   else
      printf("\nSuccessfully Connected");

   bzero(request, 1000);

   sprintf(request, "Get %s HTTP/1.1\r\nHost: %s\r\n\r\n", secondHalf, firstHalf);

   printf("\n%s", request);

   if (send(tcpSocket, request, strlen(request), 0) < 0)
      printf("Error with send()");
   else
      printf("Successfully sent html fetch request");

   bzero(request, 1000);

   recv(tcpSocket, request, 999, 0);
   printf("\n%s", request);

   close(tcpSocket);

   return (EXIT_SUCCESS);
}


void sslWrite (connection *c, char *text)
{
   if (c)
   {
      SSL_write (c->sslHandle, text, strlen (text));
   }
}

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
        ERR_print_errors_fp (stderr);

      // Create an SSL struct for the connection
      c->sslHandle = SSL_new (c->sslContext);
      if (c->sslHandle == NULL)
        ERR_print_errors_fp (stderr);

      // Connect the SSL struct to our connection
      if (!SSL_set_fd (c->sslHandle, c->socket))
        ERR_print_errors_fp (stderr);

      // Initiate SSL handshake
      if (SSL_connect (c->sslHandle) != 1)
        ERR_print_errors_fp (stderr);
    }
  else
    {
      perror ("Connect failed");
    }

  return c;
}

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
        ERR_print_errors_fp (stderr);

      // Create an SSL struct for the connection
      c->sslHandle = SSL_new (c->sslContext);
      if (c->sslHandle == NULL)
        ERR_print_errors_fp (stderr);

      // Connect the SSL struct to our connection
      if (!SSL_set_fd (c->sslHandle, c->socket))
        ERR_print_errors_fp (stderr);

      // Initiate SSL handshake
      if (SSL_connect (c->sslHandle) != 1)
        ERR_print_errors_fp (stderr);
    }
  else
    {
      perror ("Connect failed");
    }

  return c;
}
