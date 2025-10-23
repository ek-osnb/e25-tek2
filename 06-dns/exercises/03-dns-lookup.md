# DNS Lab exercises


## Exercise 1: Root DNS Servers and TLD Servers

**1. Use the `dig` command to query for the root DNS servers:**

```bash
dig NS .
```

**2. Choose one of the root servers from the output and perform a DNS query to find the TLD servers for the `.dk` domain:**

```bash
dig NS dk. @<root-server-ip>
```

**3. Choose one of the TLD servers from the output and perform a DNS query to find the authoritative name servers for `ek.dk`:**

```bash
dig NS ek.dk. @<tld-server-ip>
```

**4. Finally, use one of the authoritative name servers to find the A record for `ek.dk`:**

```bash
dig A ek.dk. @<authoritative-server-ip>
```

## Exercise 2: DNS Resolution Path
**1. Use the `dig +trace` command to perform a DNS lookup for `ek.dk`:**

```bash
dig +trace ek.dk
```

**2. Analyze the output to understand the DNS resolution path from the root servers to the authoritative name servers for `ek.dk`.**
- Which servers were queried during the resolution process?
- Retry the command a couple of times and observe if the path changes?
- Draw a diagram showing the DNS resolution path for `ek.dk`, including the root servers, TLD servers, and authoritative name servers.

## Exercise 3: CNAME chains
**1. Use the `dig` command to look up the A record for `www.ek.dk`:**

```bash
dig www.ek.dk
```
- How many CNAME records are there in the response?
- What is the final A record IP address? Is it the same as the A record for `ek.dk`?

## Exercise 3: Reflection Questions
Imagine that you are trying to visit `www.enterprise.com`, but you don't remember the IP address the web-server is running on.

**Assume the following records are on the TLD DNS server:**
- `(www.enterprise.com, dns.enterprise.com, NS)`
- `(dns.enterprise.com, 146.54.103.133, A)`

**Assume the following records are on the enterprise.com DNS server:**
- `(www.enterprise.com, west4.enterprise.com, CNAME)`
- `(west4.enterprise.com, 142.81.17.206, A)`
- `(enterprise.com, mail.enterprise.com, MX)`
- `(mail.enterprise.com, 247.29.216.152, A)`

### Questions:
1. What is the **IP address** of `www.enterprise.com`?
2. What is the **IP address** of `mail.enterprise.com`?
3. What is the purpose of the `CNAME` record in this context?
4. Explain the difference between an A record and a CNAME record.
5. In the above example, how many DNS Resource Records (RRs) are there at the authoritative DNS server for enterprise.com? List them.
6. What is the role of the TLD DNS server in the DNS resolution process?
7. Why is it important to have multiple types of DNS records (A, CNAME, MX) for a domain?
8. How does DNS caching improve the efficiency of the DNS resolution process?
9. What potential issues could arise if DNS records are not properly maintained or updated?
10. How would you use the `dig` command to verify the MX record for `enterprise.com`?
11. What is the significance of the TTL (Time to Live) value in DNS records?

