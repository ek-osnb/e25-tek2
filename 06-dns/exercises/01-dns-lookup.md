# DNS Lookup Exercise

In this exercise, you will perform DNS lookups using command-line tools to understand how DNS resolution works.

## Step 1: Using `nslookup`
1. Open your terminal.
2. Type the following command to look up the IP address of a domain (e.g., `example.com`):
   ```
    nslookup example.com
    ```
3. Observe the output, which should include the IP address associated with the domain.

## Step 2: Using `dig`
1. In the terminal, type the following command to perform a DNS lookup using `dig`:
   ```
    dig example.com
   ```

2. Review the output, which provides detailed information about the DNS query, including the answer section with the IP address.

3. Try looking up different types of DNS records (A, MX, CNAME) by using the following commands:
   - For A record:
     ```
      dig example.com A
     ```
   - For MX record:
     ```
      dig example.com MX
     ```
   - For CNAME record:
     ```
      dig example.com CNAME
     ```
## Step 3: Using `dig +trace`
1. To see the full DNS resolution path, use the `+trace` option with `dig`:
   ```
    dig +trace example.com
    ```
2. Analyze the output to understand how the DNS query is resolved step-by-step from the root servers down to the authoritative name servers for the domain.
3. Which servers were queried during the resolution process?
4. Draw a diagram showing the DNS resolution path for `example.com`, including the root servers, TLD servers, and authoritative name servers.

## Step 4: Reflection Questions
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
