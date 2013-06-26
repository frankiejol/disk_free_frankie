disk_free_frankie
=================

Calls to df and trims the output cleaning uuid and mapper from device

SYNOPSIS

    With LVM and uuid devices, using df can be a pain:

        $ df
        Filesystem                                             1K-blocks     Used 
            Available Use% Mounted on
        rootfs                                                   3842376  1493404
            2153784  41% /
        udev                                                       10240        0
            10240   0% /dev
        tmpfs                                                     103384      204
            103180   1% /run
        /dev/disk/by-uuid/6832e4f5-a260-4f25-b376-7d7175bce2a9   3842376  1493404
            2153784  41% /
    
    dff just calls df and trims the device part to make the output 
    human readable again.

        $ dff.pl
        Filesystem    1K-blocks      Used  Available  Use% Mounted on
        rootfs          3842376   1493404    2153784   41% /
        udev              10240         0      10240    0% /dev
        tmpfs            103384       204     103180    1% /run
        uuid/6832e4f    3842376   1493404    2153784   41% /
    

REQUIREMENTS

    IPC::Run Perl Module.

    Debians: 

    $ sudo apt-get install libipc-run-perl

    RPMs:

    #yum install perl-IPC-Run.noarch

INSTALLATION

    Copy the file dff.pl to some directory in your path:

    $ sudo cp dff.pl /usr/local/bin

USAGE

    Use it the same way you used df. It actually calls df, then it trims
    the device part:

        $ dff.pl [ARGS]

    If it runs well for you, use it from an alias, ie: .bashrc

        alias df=dff.pl

    dff own arguments

        If you use it as an alias, maybe one day you will need the real thing:
        
        $ dff.pl --real
        $ df --real # if you aliased df

        You can also change the length of the device part:

        alias df=dff.pl --length=19

LICENSE

    (c) 2013 Francesc Guasch Ortiz

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

