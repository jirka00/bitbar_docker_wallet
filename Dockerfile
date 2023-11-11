FROM alpine:3.18.4 as build
RUN apk add git make==4.4.1-r1 gcc==12.2.1_git20220924-r10 g++==12.2.1_git20220924-r10 musl-dev==1.2.4-r2 libressl-dev==3.7.3-r0 boost-dev==1.82.0-r1 db-dev==5.3.28-r4 elfutils-dev==0.189-r2 
RUN git clone https://github.com/Crypto-Currency/bitbar.git
WORKDIR bitbar/src
RUN sed -i 's/#include <execinfo.h>//g' init.cpp ; sed -i 's/size = backtrace(array, 50);//g' init.cpp ; sed -i 's/messages = backtrace_symbols(array, size);//g' init.cpp #remove package unsuported functions for debugging
RUN sed -i 's/#include <execinfo.h>//g' util.cpp ; sed -i 's/size = backtrace(pszBuffer, 32);//g' util.cpp ; sed -i 's/backtrace_symbols_fd(pszBuffer, size, fileno(fileout));//g' util.cpp  #remove package unsuported functions for debugging
RUN make -f makefile.unix CXXFLAGS="-std=c++14" USE_UPNP=-


FROM alpine:3.18.4
RUN apk add libressl-dev==3.7.3-r0 boost-dev==1.82.0-r1 db-dev==5.3.28-r4 elfutils-dev==0.189-r2
RUN mkdir /root/.bitbar/
COPY --from=build /bitbar/src/bitbard /root/
WORKDIR /root
EXPOSE 8777
ENTRYPOINT ["./bitbard"]

