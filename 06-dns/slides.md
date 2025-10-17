---
marp: true
title: "DNS & HTTP"
version: "1.0"
paginate: true
---

<!-- _class: lead -->

# DNS & HTTP
### 3rd semester @ Erhvervsakademi København

<style>
section.lead h1 {
  text-align: center;
  font-size: 2.5em;
}
section.lead h3 {
  text-align: center;
  opacity: 0.6;
}
</style>

---

# Outline
- What is DNS?
- IP Addresses & Hostnames
- DNS Records
- Common DNS Queries
- Hierarchical Structure of DNS
- DNS Servers: Recursive & Authoritative
- Practical Example
- Intro to Wireshark
- Intro to OSI model
- HTTP in Wireshark

---

## Why DNS?

- When you type a URL into your web browser, such as `www.ek.dk`, your computer needs to find the corresponding IP address to connect to the web server hosting that site.
- **DNS (Domain Name System)** is like the phonebook of the internet, translating **human-friendly domain names** into machine-friendly **IP addresses**.

---

## IP Addresses & Hostnames

- **Host name**: **`www.ek.dk`**
A human-readable label that is assigned to a device connected to a network. Hostnames are easier to remember than IP addresses.
    - Domain: **`ek.dk`**
    - Hostname: **`www`**
    - Top-Level Domain (TLD): **`.dk`**

- **IP Address**: **20.50.2.66**
A unique string of numbers separated by periods (IPv4) that identifies each computer using the Internet Protocol to communicate over a network.

---

## IP Addresses

**IPv4**: 
32-bit (4 bytes) address, written as four decimal numbers separated by dots:
```bash
      20 .      50  .        2 .       66
00010100 . 00110010 . 00000010 . 01000010
```
- Has a limited address space (about 4.3 billion addresses).

**IPv6**:
128-bit (16 bytes) address, written as eight groups of four **hexadecimal** digits separated by colons:
```bash
2001:0db8:85a3:0000:0000:8a2e:0370:7334
```
- Vastly larger address space (about `3.4 x 10^38` addresses).

---
## Available IP Addresses
**IPv4**:
- Approximately 4.3 billion addresses (2^32).
- The range of IP addresses is from `0.0.0.0` to `255.255.255.255`.
- But many are reserved for a special purpose:
    - Private networks: (e.g., `192.168.x.x`, `10.x.x.x`, `172.16.x.x` to `172.31.x.x`)
    - Multicast addresses: (e.g., `224.0.0.0` to `239.255.255.255`)
    - Loopback addresses: (e.g., `127.0.0.1`)

---

## Why separate Names and IP Addresses?

- **Memorability**: Domain names are easier for humans to remember than numerical IP addresses.
    - `www.ek.dk` vs `20.50.2.66`
- **Flexibility**: IP addresses can change (e.g., when a website moves to a different server), but the domain name can remain the same.
    - Moving `www.ek.dk` to a new IP address doesn't require users to learn a new address.
- **Scalability**: A single domain name can point to multiple IP addresses (e.g., for load balancing or redundancy).
    - `www.ek.dk` can resolve to multiple servers to handle more traffic.
- **Multiple aliases**:
    - `www.ek.dk`, `ek.dk` point to the same IP address.

---

## Domain Name System (DNS)

**Problem:** How do we translate domain names to IP addresses?

**Solution:** The Domain Name System (DNS) is a hierarchical system that maps domain names to IP addresses.

---

## Centralized server??

- A single server that maintains a database of domain names and their corresponding IP addresses.
- When a user wants to access a website, their computer queries this central server to get the IP address.
- All queries go to this one server.

**Question:** What are the potential issues with this approach?

---

## Domain Name System (DNS)

- Instead of a centralized server, DNS uses a **distributed** and **hierarchical** approach.
- DNS is made up of many servers around the world, each responsible for different parts of the domain name space.
- When a user wants to access a website, their computer queries multiple DNS servers in a **hierarchical** manner to resolve the domain name to an IP address.

---

## Hierarchical Structure of DNS
**DNS hierarchy is organized in levels:**
- **Root Level**: The top level, represented by a dot `.`.
- **Top-Level Domains (TLDs)**: Below the root, such as `.com`, `.org`, `.net`, and country-code TLDs like `.dk`, `.uk`, `.jp`.
- **Authoritative Servers**: Each TLD has authoritative servers that manage the next level down, which includes second-level domains (e.g., `ek` in `ek.dk`).

![dns hierarchy](assets/dns-hierarchy.png)

<style>
  img {
    max-width: 60%;
    height: auto;
    display: block;
    margin: 0 auto;
  }
</style>

---

## Root nameservers
- As of today (2025), there are 1994 root servers worldwide, operated by 12 organizations.
- There are 13 root server addresses, labeled A through M, but each address can correspond to multiple physical servers.

![root servers](assets/root-servers.png)

---

## DNS Resolution Process

- When you type a URL into your browser, your computer initiates a **DNS query** to resolve the domain name to an IP address.
![dns resolution](assets/dns-resolution.png)

---

## What happens during DNS resolution?
1. Your computer asks a **recursive resolver** (usually provided by your ISP or a public DNS service like Google DNS or Cloudflare DNS) to resolve the domain name.
2. The recursive resolver asks a **root nameserver** for the TLD (e.g., `.dk`).
3. The root nameserver responds with the address of a **TLD nameserver** for `.dk`.
4. The recursive resolver then asks the TLD nameserver for the domain (e.g., `ek.dk`).
5. The TLD nameserver responds with the address of the **authoritative nameserver** for `ek.dk`.
6. Finally, the recursive resolver asks the authoritative nameserver for the IP address of `www.ek.dk`.
7. The authoritative nameserver responds with the IP address (e.g., `20.50.2.66`).
8. The recursive resolver returns this IP address to your computer.

---

## Recursive vs. iterative queries

- **Recursive query**: It puts the burden of resolution on the DNS server. The server will query other servers on behalf of the client until it finds the answer or an error.
- **Iterative query**: The DNS server responds with the best answer it can provide based on its knowledge. If it doesn't know the answer, it will refer the client to another DNS server.

**Question:** Which type of query does your computer typically use when resolving a domain name?

---

## DNS caching

- To improve efficiency and reduce latency, **DNS responses are often cached at various levels** (e.g., on your computer, by your ISP, or by the recursive resolver).

- Cached entries have a **Time To Live (TTL)** value, which indicates how long the entry should be kept before it is considered stale and needs to be refreshed.

- **Negative caching** is also used to store information about failed lookups, preventing repeated queries for non-existent domains.

---

## DNS records

- **A Record**: Maps a domain name to an **IPv4 address**.
- **AAAA Record**: Maps a domain name to an **IPv6 address**.
- **CNAME Record**: Canonical Name record, used to alias one domain name to another. E.g., `www.kea.dk` to `kea.dk`.
- **MX Record**: Mail Exchange record, specifies the mail server responsible for receiving email on behalf of a domain.
- **TXT Record**: Text record, used to store arbitrary text data, often for verification purposes (e.g., SPF records for email).
- **NS Record**: Name Server record, indicates which DNS server is authoritative for a particular domain.

---

## DNS lookup tools

**MacOS/Linux:**
- `nslookup`
- `dig`
- `host`

**Windows:**
- `nslookup`
- `dig` using a Docker container.

---

## Practical Example: Using `dig`

```bash
$ dig ek.dk
; <<>> DiG 9.10.6 <<>> ek.dk
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 60213
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;ek.dk.				IN	A

;; ANSWER SECTION:
ek.dk.			600	IN	A	20.50.2.66

;; Query time: 24 msec
;; SERVER: 192.168.0.1#53(192.168.0.1)
;; WHEN: Tue Oct 14 14:47:30 CEST 2025
;; MSG SIZE  rcvd: 50
```

---

## Practical Example: Using `dig +trace`
Shows path from **root servers** down to the **authoritative server** for the domain.

```bash
$ dig +trace ek.dk
; <<>> DiG 9.10.6 <<>> +trace ek.dk
;; global options: +cmd
.			242548	IN	NS	m.root-servers.net.
.			242548	IN	NS	e.root-servers.net.
.			242548	IN	NS	c.root-servers.net.
.			242548	IN	NS	j.root-servers.net.
.			242548	IN	NS	b.root-servers.net.
.			242548	IN	NS	h.root-servers.net.
.			242548	IN	NS	f.root-servers.net.
.			242548	IN	NS	l.root-servers.net.
.			242548	IN	NS	d.root-servers.net.
.			242548	IN	NS	i.root-servers.net.
.			242548	IN	NS	k.root-servers.net.
.			242548	IN	NS	a.root-servers.net.
.			242548	IN	NS	g.root-servers.net.
```
---

<!-- ## Practical Example: Using `dig +trace` continued -->

```bash
;; Received 1109 bytes from 192.168.0.1#53(192.168.0.1) in 21 ms

dk.			172800	IN	NS	b.nic.dk.
dk.			172800	IN	NS	c.nic.dk.
dk.			172800	IN	NS	h.nic.dk.
dk.			172800	IN	NS	l.nic.dk.
dk.			172800	IN	NS	s.nic.dk.
dk.			172800	IN	NS	t.nic.dk.
```
---

<!-- ## Practical Example: Using `dig +trace` continued -->

```bash
;; Received 733 bytes from 170.247.170.2#53(b.root-servers.net) in 29 ms

ek.dk.			86400	IN	NS	ns.efif.dk.
ek.dk.			86400	IN	NS	ns2.efif.dk.
ek.dk.			86400	IN	NS	ns3.efif.dk.

;; Received 366 bytes from 194.0.28.7#53(s.nic.dk) in 23 ms

ek.dk.			600	IN	A	20.50.2.66
```
- The result is the IP address of `ek.dk`: `20.50.2.66`.

**Questions:** What is the TTL and which record types are returned?

---

## Exercise: DNS Lookup

1. Use **`nslookup`** to find the IP address of `ek.dk`.
2. Use **`dig`** to perform a DNS query for `ek.dk` and analyze the output.
3. Use **`dig +trace ek.dk`** to see the full resolution path from the root servers down to the authoritative server.
    - Which servers were contacted?
    - Identify the root, TLD and authoritative servers.
    - Do it repeatedly what happens to the results?

---

## What is a resolver?

A **resolver** is a server that receives DNS queries from client devices (like your computer or smartphone) and is responsible for finding the corresponding IP address for a given domain name. There are two main types of resolvers:

1. **Recursive Resolvers**: These resolvers take on the task of querying multiple DNS servers on behalf of the client until they find the authoritative answer. They cache the results to improve performance for future queries.

2. **Iterative Resolvers**: These resolvers return the best answer they have (which may not be the final answer) and rely on the client to continue the query process. They typically provide referrals to other DNS servers that may have the answer.

**Question:** How does your computer know which resolver to use?

---

## Inserting records into DNS

- DNS records are typically managed by the domain owner through a DNS hosting provider or registrar.
- Changes to DNS records (like adding an A record or MX record) are made through a web interface or API provided by the DNS hosting service.
- Once changes are made, they need to propagate through the DNS system, which can take time due to caching and TTL values.
- The TTL (Time To Live) value determines how long a DNS record is cached by resolvers before they must query the authoritative server again for updated information.

---

## Security Considerations
- **DNS Spoofing/Cache Poisoning**: Attackers can manipulate DNS responses to redirect users to malicious sites.
- **DNSSEC (DNS Security Extensions)**: A suite of extensions that add a layer of security to DNS by enabling DNS responses to be verified for authenticity.
- **Privacy Concerns**: DNS queries can reveal browsing habits; using encrypted DNS (like DNS over HTTPS or DNS over TLS) can help mitigate this.
- **DDoS Attacks**: DNS servers can be targeted in Distributed Denial of Service attacks, overwhelming them with traffic and making them unavailable.

---

# Example: Registering a domain and setting up DNS records
- Register a domain through a registrar (simply.com, one.com, etc.).
- Use the registrar's DNS management tools to add records:
    - Add an A record to point `yourdomain.com` to your server's IP address.
    - Add a CNAME record for `www.yourdomain.com` to point to `yourdomain.com`.
- We need a web server to respond to HTTP requests.

---

## Exercise: Setting up DNS records
1. Register a domain name through a registrar (e.g., simply.com, one.com).
2. Use the registrar's DNS management tools to add the following records:
    - An A record to point `yourdomain.com` to a public IP address (you can use a placeholder IP if you don't have one).
    - A CNAME record for `www.yourdomain.com` to point to `yourdomain.com`.
3. Use `dig` or `nslookup` to verify that the records have been added correctly.

---

# Adding SSL to a nginx server

When hosting a website, it's important to secure the connection using SSL/TLS. This ensures that data transmitted between the user's browser and the web server is **encrypted**.
- Encryption protects the data from being intercepted by malicious actors.

- SSL/TLS also provides **authentication**, ensuring that users are connecting to the legitimate website and not an imposter.


---

# Practical Example: Using Let's Encrypt with Nginx

1. On the VM hosting your Nginx server, install Certbot:
    ```bash
    sudo apt-get update
    sudo apt-get install certbot python3-certbot-nginx
    ```
2. Obtain an SSL certificate for your domain:
    ```bash
    sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
    ```
3. Follow the prompts to complete the certificate installation.
4. Certbot will automatically configure Nginx to use the new SSL certificate.

**Replace `yourdomain.com` with your actual domain name.**


---

# Exercise: Setting up SSL with Let's Encrypt

---

## Using Digital Oceans DNS management
**Why change DNS providers?**
- Centralized management for multiple domains.
- Easy to update records.
- Reliable DNS hosting.
- Digital Ocean exposes a simple UI and **REST API** for managing DNS records.
- It's free to use if you have a Digital Ocean account.

---

## HTTP: Hypertext Transfer Protocol
- HTTP is the protocol used for transferring web pages on the internet.
- It is an application-layer protocol that operates over TCP/IP (more on TCP/IP later).
- HTTP defines how messages are formatted and transmitted, and how web servers and browsers should respond to various commands.
- HTTP is **stateless**, meaning each request from a client to a server is independent and unrelated to previous requests.
- HTTP (HTTP/1.0) is defined in **RFC 1945**.


---
## HTTP methods
- **GET**: Requests data from a specified resource. (e.g., loading a webpage)
- **POST**: Submits data to be processed to a specified resource. (e.g., submitting a form)
- **PUT**: Updates a current resource with new data.
- **DELETE**: Deletes the specified resource.
- **HEAD**: Similar to GET but only requests the headers, not the body.
- **OPTIONS**: Describes the communication options for the target resource.

---

## HTTP Status Codes
- **1xx (Informational)**: Request received, continuing process.
- **2xx (Success)**: The request was successfully received, understood, and accepted.
    - `200 OK`: The request has succeeded.

- **3xx (Redirection)**: Further action needs to be taken to complete the request.
    - `301 Moved Permanently`: The resource has been moved to a new URL.
    - `302 Found`: The resource is temporarily located at a different URL.
- **4xx (Client Error)**: The request contains bad syntax or cannot be fulfilled.
    - `404 Not Found`: The requested resource could not be found.
    - `403 Forbidden`: The server understood the request but refuses to authorize it.
- **5xx (Server Error)**: The server failed to fulfill a valid request.
    - `500 Internal Server Error`: A generic error message when the server encounters an unexpected condition.
    - `502 Bad Gateway`: The server received an invalid response from the upstream server.

---

## HTTP headers
- HTTP headers are key-value pairs sent between the client and server to provide additional information about the request or response.
- Common request headers:
    - `Host`: Specifies the domain name of the server (e.g., `www.ek.dk`).
    - `Accept`: Specifies the media types that the client can process (e.g., `text/html`, `application/json`).
- Common response headers:
    - `Content-Type`: Indicates the media type of the resource (e.g., `text/html`).
    - `Content-Length`: The size of the response body in bytes.

---

## HTTP format example

```bash
+-----------------------------------------------------+
| GET /index.html HTTP/1.1                            |  <-- Request Line
+-----------------------------------------------------+
| Host: www.ek.dk                                     |  <-- Header
| User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)|  <-- Header
| Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8 |  <-- Header
| Accept-Language: en-US,en;q=0.5                |  <-- Header
| Accept-Encoding: gzip, def
```

---

## Intro to Wireshark
- Wireshark is a network protocol analyzer that captures and displays network traffic in real-time.
- It allows you to see the details of network packets, including headers and payloads.
- Useful for troubleshooting network issues, analyzing protocols, and learning about network communication.
- Supports filtering, searching, and exporting packet data.
- Wireshark decomposes network traffic into its component protocols, and displays the details according to the OSI model (or TCP/IP model).

**But what is the OSI model?**

---

## OSI Model Overview 
The OSI (Open Systems Interconnection) model is a conceptual framework used to understand and implement network protocols in seven layers.

**1. Physical Layer:** Deals with the physical connection between devices (e.g., cables, switches).
**2. Data Link Layer:** Manages data frames between devices on the same network (e.g., Ethernet, MAC addresses).
**3. Network Layer:** Handles routing of data packets across networks (e.g., IP addresses).
**4. Transport Layer:** Ensures reliable data transfer between devices (e.g., TCP, UDP).
**5. Session Layer:** Manages sessions or connections between applications.
**6. Presentation Layer:** Translates data formats and encrypts/decrypts data.
**7. Application Layer:** Interfaces with end-user applications (e.g., HTTP, FTP, DNS).

---

## OSI vs TCP/IP Model
- The OSI model has 7 layers, while the TCP/IP model has 4 layers.
- The TCP/IP model is more practical and widely used in real-world networking.

![OSI vs TCP](assets/OSI-vs-TCP.webp)

---

# Protocols

### A protocol is a **set of rules** that govern how data is transmitted and received over a network. 

### Different protocols operate at different layers of the OSI or TCP/IP model.

<!-- **Examples of common protocols:**
- HTTP/HTTPS
- DNS -->

---

## DNS protocol format

```bash
            +----------------------+----------------------+
            | Identification       | Flags                |
            +----------------------+----------------------+
            | Number of Questions  | Number of Answers    |
            +----------------------+----------------------+
            | Number of Authority  | Number of Additional |
            +----------------------+----------------------+
            | Questions                                   |
            +---------------------------------------------+
            | Answers                                     |
            +---------------------------------------------+
            | Authority                                   |
            +---------------------------------------------+
            | Additional                                  |
            +---------------------------------------------+
```

---

## Example: DNS query (in readable format)

```bash
            |----------------- 4 bytes -------------------|

            +----------------------+----------------------+
            | ID: 0x97cd           | Flags: 0x0120        |
            +----------------------+----------------------+
            | QDCOUNT: 0x0001      | ANCOUNT: 0x0000      |
            +----------------------+----------------------+
            | NSCOUNT: 0x0000      | ARCOUNT: 0x0001      |
            +----------------------+----------------------+
    QUERY:  | Name: ek.dk, Type: A, Class: IN             |
            +---------------------------------------------+
Additional: | Name: <ROOT>, Type: OPT,                    | 
            | UDP Payload Size: 0x1000                    |
            | RCODE: 0x00                                 |
            | EDNS Version: 0x00                          |
            | Z: 0x0000                                   |
            +---------------------------------------------+
```
---
## DNS Query vs Reply

**Request:**
```bash
0000   97 cd 01 20 00 01 00 00 00 00 00 01 02 65 6b 02
0010   64 6b 00 00 01 00 01 00 00 29 10 00 00 00 00 00
0020   00 00
```
**Reply:**
```bash
0000   97 cd 81 80 00 01 00 01 00 00 00 01 02 65 6b 02
0010   64 6b 00 00 01 00 01 c0 0c 00 01 00 01 00 00 01
0020   e1 00 04 14 32 02 42 00 00 29 10 00 00 00 00 00
0030   00 00
```
**Difficult to read, right? Let's use Wireshark instead!**

---
## Wireshark: Capturing DNS Traffic

- Open Wireshark and start a capture on your network interface (e.g., Wi-Fi).
- Use a filter to display only DNS traffic: `dns`

![alt text](image.png)


---

## Wireshark: DNS Query
![alt text](assets/wireshark-dns-query.png)

<style>
  img {
    max-width: 50%;
    height: auto;
    display: block;
    margin: 0 auto;
  }
</style>

---
## Wireshark: DNS Reply
![alt text](assets/wireshark-dns-reply.png)

---

## Wireshark

Wireshark can capture network traffic and display it in a human-readable format.
- You can filter traffic by protocol (e.g., `dns`, `http`).
- There is extra information about each layer - we will explore this in the next lecture.

---

# Summary
- DNS translates human-friendly domain names into machine-friendly IP addresses.
- DNS is hierarchical and distributed, involving multiple types of servers (root, TLD, authoritative).
- Common DNS records include A, AAAA, CNAME, MX, TXT, and NS records.
- DNS queries can be recursive or iterative, and caching is used to improve performance.
- Wireshark is a tool for capturing and analyzing network traffic, including DNS queries and responses.

---

## Exercises: Capture DNS traffic using Wireshark
1. Start a Wireshark capture on your network interface.
2. Use a filter to display only DNS traffic: `dns`.
3. Visit a website (e.g., `www.ek.dk`) in your web browser.
4. Analyze the DNS query and response packets to identify the different fields and their values.
    - What is the transaction ID?
    - What type of query was made (e.g., A, AAAA, CNAME)?
    - What is the IP address returned in the response?
    - What is the TTL value in the response?
    - How many answers are included in the response?

---

## Eksempler på DNS-spørgsmål til eksamen:
1. Hvem bestemmer hvilken IP-adresse et domæne peger på?
2. Hvilke slags DNS record-typer findes der?
3. Hvad er TTL for en DNS record, og hvorfor sætter man den højt
eller lavt?
4. Hvad er forskellen på en autoritativ navneserver og en cachende
navneserver?
5. Hvordan fungerer en rekursiv resolver?

---

## Eksempler på DNS demonstrationer til eksamen:
1. Lav et simpelt DNS-opslag med nslookup eller host på domænet
kea.dk og forklar
2. Lav et avanceret DNS-opslag med dig eller dnschecker.org på
domænet kea.dk og forklar
3. Vis trafikken i Wireshark når du laver et DNS-opslag på domænet og forklar.
