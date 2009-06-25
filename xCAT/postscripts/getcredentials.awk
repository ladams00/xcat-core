#!/usr/bin/awk -f
BEGIN {
        server = "openssl s_client -quiet -connect " ENVIRON["XCATSERVER"]
        quit = "no"


        print "<xcatrequest>" |& server
        print "   <command>getcredentials</command>" |& server
        print "   <callback_port>300</callback_port>" |& server
        for (i=1; i<ARGC; i++) 
            print "   <arg>"ARGV[i]"</arg>" |& server
        print "</xcatrequest>" |& server

        while (server |& getline) {
                print $0
                if (match($0,"<serverdone>")) {
                  quit = "yes"
                }
                if (match($0,"</xcatresponse>") && match(quit,"yes")) {
                  close(server)
                  exit
               }
        }
}
