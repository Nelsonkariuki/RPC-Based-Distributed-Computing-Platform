# Makefile for RPC-based Distributed Computing Platform
# For libtirpc on modern Linux systems

CC = gcc
CFLAGS = -g -Wall -I/usr/include/tirpc
LDFLAGS = -ltirpc
RPCGEN = rpcgen
RM = rm -f

# Source files
X_FILE = replicate.x
CLIENT_SRC = replicate_client.c
SERVER_SRC = replicate_server.c

# Generated files
GEN_H = replicate.h
GEN_XDR = replicate_xdr.c
GEN_CLNT = replicate_clnt.c
GEN_SVC = replicate_svc.c

# Object files
CLIENT_OBJ = replicate_client.o replicate_clnt.o replicate_xdr.o
SERVER_OBJ = replicate_server.o replicate_svc.o replicate_xdr.o

# Targets
TARGETS = replicate_client replicate_server

all: $(TARGETS)

# Generate RPC stubs - ensure all files are generated
$(GEN_H) $(GEN_XDR) $(GEN_CLNT) $(GEN_SVC): $(X_FILE)
	$(RPCGEN) -C $(X_FILE)
	@echo "Generated RPC stubs"

# Client executable
replicate_client: $(CLIENT_OBJ)
	$(CC) -o $@ $(CLIENT_OBJ) $(LDFLAGS)

# Server executable
replicate_server: $(SERVER_OBJ)
	$(CC) -o $@ $(SERVER_OBJ) $(LDFLAGS)

# Compile rules
%.o: %.c $(GEN_H)
	$(CC) $(CFLAGS) -c $< -o $@

# Special rule for generated files
replicate_clnt.o: replicate_clnt.c $(GEN_H)
	$(CC) $(CFLAGS) -c replicate_clnt.c -o $@

replicate_svc.o: replicate_svc.c $(GEN_H)
	$(CC) $(CFLAGS) -c replicate_svc.c -o $@

replicate_xdr.o: replicate_xdr.c $(GEN_H)
	$(CC) $(CFLAGS) -c replicate_xdr.c -o $@

# If replicate_xdr.c doesn't exist, create an empty one
replicate_xdr.c: $(X_FILE)
	$(RPCGEN) -C -m $(X_FILE) > replicate_xdr.c || touch replicate_xdr.c

clean:
	$(RM) $(GEN_H) $(GEN_XDR) $(GEN_CLNT) $(GEN_SVC)
	$(RM) *.o $(TARGETS)

distclean: clean
	$(RM) *~

.PHONY: all clean distclean
