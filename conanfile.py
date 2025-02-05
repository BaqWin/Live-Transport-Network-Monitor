from conan import ConanFile

class NetworkMonitorConan(ConanFile):
    name = "network-monitor"
    version = "0.1.0"
    settings = "os", "arch", "compiler", "build_type"

    generators = "CMakeDeps", "CMakeToolchain"

    requires = [
        "boost/1.82.0",
    ]

    default_options = {
        "boost/*:shared": False,
    }
