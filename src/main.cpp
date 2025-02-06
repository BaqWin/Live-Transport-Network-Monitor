#include <boost/asio.hpp>
#include <boost/system/error_code.hpp>
#include <boost/beast.hpp>
#include <boost/beast/core.hpp>
#include <boost/beast/websocket.hpp>
#include <boost/beast/websocket/stream.hpp>

#include <iomanip>
#include <iostream>
#include <thread>
#include <string>

namespace beast = boost::beast;
namespace websocket = beast::websocket;
namespace net = boost::asio;
using tcp = boost::asio::ip::tcp;

void Log(boost::system::error_code ec){
    std::cerr << "[" << std::setw(14) << std::this_thread::get_id() << "] "
              << (ec ? "Error" : "OK")
              << (ec ? ec.message() : "")
              << std::endl;
}

void OnConnect(boost::system::error_code ec){
    Log(ec);
}

int main(){
    std::string url = "ltnm.learncppthroughprojects.com";
    std::string port = "80";
    std::string message = "Hello World!";

    boost::asio::io_context ioc{};

    boost::system::error_code ec{};
    tcp::resolver resolver{ioc};
    auto resolverIt{resolver.resolve(url, port, ec)};

    if(ec){
        Log(ec);
        return -1;
    }

    tcp::socket socket{ioc};
    socket.connect(*resolverIt,  ec);

    if(ec){
        Log(ec);
        return -2;
    }

    websocket::stream<boost::beast::tcp_stream> ws{std::move(socket)};
    ws.handshake(url, "/echo", ec);

    ws.text(true);
    boost::asio::const_buffer wbuffer{message.c_str(), message.size()};
    ws.write(wbuffer, ec);

    boost::beast::flat_buffer rbuffer{};
    ws.read(rbuffer, ec);

    if(ec){
        Log(ec);
        return -3;
    }

    std::cout << "Echo: "
              << boost::beast::make_printable(rbuffer.data())
              << std::endl;

    return 0;
}
