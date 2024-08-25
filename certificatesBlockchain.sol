// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SkillCredentialing {
    struct Certificate {
        string courseName;
        string studentName;
        uint256 issueDate;
        bool valid;
    }

    mapping(bytes32 => Certificate) public certificates;
    
    event CertificateIssued(bytes32 indexed certHash, string courseName, string studentName);
    event CertificateRevoked(bytes32 indexed certHash);

    function issueCertificate(string memory _courseName, string memory _studentName) public returns (bytes32) {
        bytes32 certHash = keccak256(abi.encodePacked(_courseName, _studentName, block.timestamp));
        certificates[certHash] = Certificate(_courseName, _studentName, block.timestamp, true);
        emit CertificateIssued(certHash, _courseName, _studentName);
        return certHash;
    }

    function revokeCertificate(bytes32 _certHash) public{
        require(certificates[_certHash].valid, "Certificate is already revoked or does not exist.");
        certificates[_certHash].valid = false;
        emit CertificateRevoked(_certHash);
    }

    function verifyCertificate(bytes32 _certHash) public view returns (bool) {
        return certificates[_certHash].valid;
    }
}
