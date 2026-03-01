cmake_minimum_required(VERSION 3.10)
project("m7secrets")

add_library(
    m7secrets
    SHARED
    secrets.cpp
)

find_library(log-lib log)

target_link_libraries(m7secrets ${log-lib})
