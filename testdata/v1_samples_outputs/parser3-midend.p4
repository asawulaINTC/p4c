#include "/home/cdodd/p4c/build/../p4include/core.p4"
#include "/home/cdodd/p4c/build/../p4include/v1model.p4"

header data1_t {
    bit<32> f1;
    bit<2>  x1;
    bit<4>  x2;
    bit<4>  x3;
    bit<4>  x4;
    bit<2>  x5;
    bit<5>  x6;
    bit<2>  x7;
    bit<1>  x8;
}

header data2_t {
    bit<8> a1;
    bit<4> a2;
    bit<4> a3;
    bit<8> a4;
    bit<4> a5;
    bit<4> a6;
}

struct metadata {
}

struct headers {
    @name("data1") 
    data1_t data1;
    @name("data2") 
    data2_t data2;
}

parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("parse_data2") state parse_data2 {
        packet.extract(hdr.data2);
        transition accept;
    }
    @name("start") state start {
        packet.extract(hdr.data1);
        transition select(hdr.data1.x3, hdr.data1.x1, hdr.data1.x7) {
            (4w0xe, 2w0x1, 2w0x0): parse_data2;
            default: accept;
        }
    }
}

control ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("noop") action noop() {
        bool hasReturned_1 = false;
    }
    @name("test1") table test1() {
        actions = {
            noop;
            NoAction;
        }
        key = {
            hdr.data1.f1: exact;
        }
        default_action = NoAction();
    }

    apply {
        bool hasReturned_0 = false;
        test1.apply();
    }
}

control egress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
        bool hasReturned_2 = false;
    }
}

control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
        bool hasReturned_3 = false;
        packet.emit(hdr.data1);
        packet.emit(hdr.data2);
    }
}

control verifyChecksum(in headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
        bool hasReturned_4 = false;
    }
}

control computeChecksum(inout headers hdr, inout metadata meta) {
    apply {
        bool hasReturned_5 = false;
    }
}

V1Switch(ParserImpl(), verifyChecksum(), ingress(), egress(), computeChecksum(), DeparserImpl()) main;
