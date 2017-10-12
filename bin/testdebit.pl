#!/usr/bin/perl -w
use strict;

###################### testdebit.pl ######################
# Script perl de test de débit pour Linux version 1.0 du 16 septembre 2014
# Écrit par Vivien GUEANT sous Licence publique générale GNUv3
# Contact / Questions : https://lafibre.info/tester-son-debit/

###################### FONCTIONNEMENT ######################
# Ce script fait un téléchargement / upload d'un fichier
# De nombreuses données sur les anomalies pendant le transfert
# L'absence de ligne "anomalies" signifie que tout s'est déroulé idéalement

###################### MODE D'EMPLOI ######################
# Pour rendre ce script exécutable : dans un terminal, tapez « chmod +x testdebit.pl »
#
# Installation des dépendances pour linux Ubuntu/Debian : sudo apt-get install curl
# 
# Le lancement se fait dans un terminal :
# Ex pour le download :  ./testdebit.pl -d -4 http://bouygues.testdebit.info/100M.iso
# Ex pour l'upload    :  ./testdebit.pl -u -4 http://bouygues.testdebit.info 10M.iso

############# INITIALISATION DES VARIABLES #################
my $type_test = "0";
my $serveur_proto = "0";
my $serveur_url = "0";
my $fichier = "0";
my $perte = "0";
my $anomalie = "0";
my $anomalie_critique = "0";
my @netstat1 = "";
my @netstat2 = "";
my @netstat3 = "";
my @curl1 = "";

######################### ARGUMENTS PASSES EN LIGNE DE COMMANDE #################################
if("$ARGV[0]" eq "-d") { # 1er argument :  -d (download) ou -u (upload)
	$type_test = "download";
	if("$ARGV[2]" ne "") { # 3ème argument pour : url http ou https
		$serveur_url = "$ARGV[2]";
	} else {
		die ("3ème argument : Il faut spécifier l'url avec le fichier à télécharger\n");
	}
}
elsif("$ARGV[0]" eq "-u") {
	if("$ARGV[3]" eq "") {
		die ("3ème argument: url du serveur\n4ème argument : fichier a uploader\n");
	}
	$serveur_url = "$ARGV[2]"; # 3ème argument : url http ou https
	$fichier = "$ARGV[3]";     # 4ème argument : le fichier à uploader
	if (-r "$fichier") {       # Vérification que le fichier existe et est lisible
		$type_test = "upload";
	}
	else {
		die "Le fichier $fichier n'existe pas ou n'est pas lisible\n";
	}
}
else {
	die ("1er argument : Il faut spécifier -d pour download ou -u pour upload dans le 1er argument\n");
}

if("$ARGV[1]" eq "-4") { # 2ème argument : -4 (IPv4) ou -6 (IPv6)
	$serveur_proto = "4";
} elsif("$ARGV[1]" eq "-6") {
	$serveur_proto = "6";
} else {
	die ("2ème argument : Il faut spécifier -4 pour IPv4 ou -6 pour IPv6\n");
}

############# INITIALISATION DU FICHIER DE LOG #################
my $LOGFILE_NAME = "/tmp/testdebit.log";
open(LOG, ">>$LOGFILE_NAME") || die "Erreur, impossible d'ouvrir le fichier de log $LOGFILE_NAME";

###################### GENERATION DE LA DATE ######################
my $time = localtime(time);
my $Annee = substr($time,length($time)-4);
my $Jour = substr($time,8,2);
my $Mois = substr($time,4,3);
my $Heure = substr($time,length($time)-13,5); # Calcul de l'heure avec les minutes, sans les secondes
my $Date = $Jour." ".$Mois.". ".$Annee;

###################### Récupération des informaiton réseau de référence SNMP1 ######################
@netstat1 = `cat /proc/net/snmp`;

###################### Post-traitement données brut SNMP1 ######################
@netstat2 = grep( /Ip: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $Ip____1_01 = $netstat3[1];
my $Ip____1_02 = $netstat3[2];
my $Ip____1_03 = $netstat3[3];
my $Ip____1_04 = $netstat3[4];
my $Ip____1_05 = $netstat3[5];
my $Ip____1_06 = $netstat3[6];
my $Ip____1_07 = $netstat3[7];
my $Ip____1_08 = $netstat3[8];
my $Ip____1_09 = $netstat3[9];
my $Ip____1_10 = $netstat3[10];
my $Ip____1_11 = $netstat3[11];
my $Ip____1_12 = $netstat3[12];
my $Ip____1_13 = $netstat3[13];
my $Ip____1_14 = $netstat3[14];
my $Ip____1_15 = $netstat3[15];
my $Ip____1_16 = $netstat3[16];
my $Ip____1_17 = $netstat3[17];
my $Ip____1_18 = $netstat3[18];
my $Ip____1_19 = $netstat3[19];
@netstat2 = grep( /Icmp: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $Icmp__1_01 = $netstat3[1];
my $Icmp__1_02 = $netstat3[2];
my $Icmp__1_03 = $netstat3[3];
my $Icmp__1_04 = $netstat3[4];
my $Icmp__1_05 = $netstat3[5];
my $Icmp__1_06 = $netstat3[6];
my $Icmp__1_07 = $netstat3[7];
my $Icmp__1_08 = $netstat3[8];
my $Icmp__1_09 = $netstat3[9];
my $Icmp__1_10 = $netstat3[10];
my $Icmp__1_11 = $netstat3[11];
my $Icmp__1_12 = $netstat3[12];
my $Icmp__1_13 = $netstat3[13];
my $Icmp__1_14 = $netstat3[14];
my $Icmp__1_15 = $netstat3[15];
my $Icmp__1_16 = $netstat3[16];
my $Icmp__1_17 = $netstat3[17];
my $Icmp__1_18 = $netstat3[18];
my $Icmp__1_19 = $netstat3[19];
my $Icmp__1_20 = $netstat3[20];
my $Icmp__1_21 = $netstat3[21];
my $Icmp__1_22 = $netstat3[22];
my $Icmp__1_23 = $netstat3[23];
my $Icmp__1_24 = $netstat3[24];
my $Icmp__1_25 = $netstat3[25];
my $Icmp__1_26 = $netstat3[26];
my $Icmp__1_27 = $netstat3[27];
@netstat2 = grep( /IcmpMsg: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $IcmpMs1_01 = $netstat3[1];
my $IcmpMs1_02 = $netstat3[2];
@netstat2 = grep( /Tcp: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $Tcp___1_01 = $netstat3[1];
my $Tcp___1_02 = $netstat3[2];
my $Tcp___1_03 = $netstat3[3];
my $Tcp___1_04 = $netstat3[4];
my $Tcp___1_05 = $netstat3[5];
my $Tcp___1_06 = $netstat3[6];
my $Tcp___1_07 = $netstat3[7];
my $Tcp___1_08 = $netstat3[8];
my $Tcp___1_09 = $netstat3[9];
my $Tcp___1_10 = $netstat3[10];
my $Tcp___1_11 = $netstat3[11];
my $Tcp___1_12 = $netstat3[12];
my $Tcp___1_13 = $netstat3[13];
my $Tcp___1_14 = $netstat3[14];
my $Tcp___1_15 = $netstat3[15];
@netstat2 = grep( /Udp: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $Udp___1_01 = $netstat3[1];
my $Udp___1_02 = $netstat3[2];
my $Udp___1_03 = $netstat3[3];
my $Udp___1_04 = $netstat3[4];
my $Udp___1_05 = $netstat3[5];
my $Udp___1_06 = $netstat3[6];
my $Udp___1_07 = $netstat3[7];
@netstat2 = grep( /UdpLite: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $UdpLit1_01 = $netstat3[1];
my $UdpLit1_02 = $netstat3[2];
my $UdpLit1_03 = $netstat3[3];
my $UdpLit1_04 = $netstat3[4];
my $UdpLit1_05 = $netstat3[5];
my $UdpLit1_06 = $netstat3[6];
my $UdpLit1_07 = $netstat3[7];

###################### Récupération des informaiton réseau de référence NETSTAT1 ######################
@netstat1 = `cat /proc/net/netstat`;

###################### Post-traitement données brut NETSTAT1 ######################
@netstat2 = grep( /TcpExt: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $TcpExt1_01 = $netstat3[1];
my $TcpExt1_02 = $netstat3[2];
my $TcpExt1_03 = $netstat3[3];
my $TcpExt1_04 = $netstat3[4];
my $TcpExt1_05 = $netstat3[5];
my $TcpExt1_06 = $netstat3[6];
my $TcpExt1_07 = $netstat3[7];
my $TcpExt1_08 = $netstat3[8];
my $TcpExt1_09 = $netstat3[9];
my $TcpExt1_10 = $netstat3[10];
my $TcpExt1_11 = $netstat3[11];
my $TcpExt1_12 = $netstat3[12];
my $TcpExt1_13 = $netstat3[13];
my $TcpExt1_14 = $netstat3[14];
my $TcpExt1_15 = $netstat3[15];
my $TcpExt1_16 = $netstat3[16];
my $TcpExt1_17 = $netstat3[17];
my $TcpExt1_18 = $netstat3[18];
my $TcpExt1_19 = $netstat3[19];
my $TcpExt1_20 = $netstat3[20];
my $TcpExt1_21 = $netstat3[21];
my $TcpExt1_22 = $netstat3[22];
my $TcpExt1_23 = $netstat3[23];
my $TcpExt1_24 = $netstat3[24];
my $TcpExt1_25 = $netstat3[25];
my $TcpExt1_26 = $netstat3[26];
my $TcpExt1_27 = $netstat3[27];
my $TcpExt1_28 = $netstat3[28];
my $TcpExt1_29 = $netstat3[29];
my $TcpExt1_30 = $netstat3[30];
my $TcpExt1_31 = $netstat3[31];
my $TcpExt1_32 = $netstat3[32];
my $TcpExt1_33 = $netstat3[33];
my $TcpExt1_34 = $netstat3[34];
my $TcpExt1_35 = $netstat3[35];
my $TcpExt1_36 = $netstat3[36];
my $TcpExt1_37 = $netstat3[37];
my $TcpExt1_38 = $netstat3[38];
my $TcpExt1_39 = $netstat3[39];
my $TcpExt1_40 = $netstat3[40];
my $TcpExt1_41 = $netstat3[41];
my $TcpExt1_42 = $netstat3[42];
my $TcpExt1_43 = $netstat3[43];
my $TcpExt1_44 = $netstat3[44];
my $TcpExt1_45 = $netstat3[45];
my $TcpExt1_46 = $netstat3[46];
my $TcpExt1_47 = $netstat3[47];
my $TcpExt1_48 = $netstat3[48];
my $TcpExt1_49 = $netstat3[49];
my $TcpExt1_50 = $netstat3[50];
my $TcpExt1_51 = $netstat3[51];
my $TcpExt1_52 = $netstat3[52];
my $TcpExt1_53 = $netstat3[53];
my $TcpExt1_54 = $netstat3[54];
my $TcpExt1_55 = $netstat3[55];
my $TcpExt1_56 = $netstat3[56];
my $TcpExt1_57 = $netstat3[57];
my $TcpExt1_58 = $netstat3[58];
my $TcpExt1_59 = $netstat3[59];
my $TcpExt1_60 = $netstat3[60];
my $TcpExt1_61 = $netstat3[61];
my $TcpExt1_62 = $netstat3[62];
my $TcpExt1_63 = $netstat3[63];
my $TcpExt1_64 = $netstat3[64];
my $TcpExt1_65 = $netstat3[65];
my $TcpExt1_66 = $netstat3[66];
my $TcpExt1_67 = $netstat3[67];
my $TcpExt1_68 = $netstat3[68];
my $TcpExt1_69 = $netstat3[69];
my $TcpExt1_70 = $netstat3[70];
my $TcpExt1_71 = $netstat3[71];
my $TcpExt1_72 = $netstat3[72];
my $TcpExt1_73 = $netstat3[73];
my $TcpExt1_74 = $netstat3[74];
my $TcpExt1_75 = $netstat3[75];
my $TcpExt1_76 = $netstat3[76];
my $TcpExt1_77 = $netstat3[77];
my $TcpExt1_78 = $netstat3[78];
my $TcpExt1_79 = $netstat3[79];
my $TcpExt1_80 = $netstat3[80];
my $TcpExt1_81 = $netstat3[81];
my $TcpExt1_82 = $netstat3[82];
my $TcpExt1_83 = $netstat3[83];
my $TcpExt1_84 = $netstat3[84];
my $TcpExt1_85 = $netstat3[85];
my $TcpExt1_86 = $netstat3[86];
my $TcpExt1_87 = $netstat3[87];
my $TcpExt1_88 = $netstat3[88];
my $TcpExt1_89 = $netstat3[89];
my $TcpExt1_90 = $netstat3[90];
my $TcpExt1_91 = $netstat3[91];
my $TcpExt1_92 = $netstat3[92];
my $TcpExt1_93 = $netstat3[93];
my $TcpExt1_94 = $netstat3[94];
my $TcpExt1_95 = $netstat3[95];
@netstat2 = grep( /IpExt: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $Ip_Ext1_01 = $netstat3[1];
my $Ip_Ext1_02 = $netstat3[2];
my $Ip_Ext1_03 = $netstat3[3];
my $Ip_Ext1_04 = $netstat3[4];
my $Ip_Ext1_05 = $netstat3[5];
my $Ip_Ext1_06 = $netstat3[6];
my $Ip_Ext1_07 = $netstat3[7];
my $Ip_Ext1_08 = $netstat3[8];
my $Ip_Ext1_09 = $netstat3[9];
my $Ip_Ext1_10 = $netstat3[10];
my $Ip_Ext1_11 = $netstat3[11];
my $Ip_Ext1_12 = $netstat3[12];
my $Ip_Ext1_13 = $netstat3[13];
my $Ip_Ext1_14 = $netstat3[14];
my $Ip_Ext1_15 = $netstat3[15];
my $Ip_Ext1_16 = $netstat3[16];
my $Ip_Ext1_17 = $netstat3[17];

###################### Téléchargement CURL ######################
if("$type_test" eq "download") {
	print ("Fichier en cours de téléchargement : $serveur_url\n");
	@curl1 = `curl -$serveur_proto -s -w %{speed_download}-%{time_namelookup}-%{time_connect}-%{time_starttransfer}-%{time_total}-%{size_download} -o /dev/null "$serveur_url"`;
}

if("$type_test" eq "upload") {
	print ("Fichier en cours d'upload : $fichier vers $serveur_url\n");
	@curl1 = `curl -$serveur_proto -s -w %{speed_upload}-%{time_namelookup}-%{time_connect}-%{time_starttransfer}-%{time_total}-%{size_upload} -F filecontent=@"$fichier" -o /dev/null "$serveur_url"`;
}

###################### Récupération des informaiton réseau de référence SNMP2 ######################
@netstat1 = `cat /proc/net/snmp`;

###################### Post-traitement données brut SNMP2 ######################
@netstat2 = grep( /Ip: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $Ip____2_01 = $netstat3[1];
my $Ip____2_02 = $netstat3[2];
my $Ip____2_03 = $netstat3[3];
my $Ip____2_04 = $netstat3[4];
my $Ip____2_05 = $netstat3[5];
my $Ip____2_06 = $netstat3[6];
my $Ip____2_07 = $netstat3[7];
my $Ip____2_08 = $netstat3[8];
my $Ip____2_09 = $netstat3[9];
my $Ip____2_10 = $netstat3[10];
my $Ip____2_11 = $netstat3[11];
my $Ip____2_12 = $netstat3[12];
my $Ip____2_13 = $netstat3[13];
my $Ip____2_14 = $netstat3[14];
my $Ip____2_15 = $netstat3[15];
my $Ip____2_16 = $netstat3[16];
my $Ip____2_17 = $netstat3[17];
my $Ip____2_18 = $netstat3[18];
my $Ip____2_19 = $netstat3[19];
@netstat2 = grep( /Icmp: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $Icmp__2_01 = $netstat3[1];
my $Icmp__2_02 = $netstat3[2];
my $Icmp__2_03 = $netstat3[3];
my $Icmp__2_04 = $netstat3[4];
my $Icmp__2_05 = $netstat3[5];
my $Icmp__2_06 = $netstat3[6];
my $Icmp__2_07 = $netstat3[7];
my $Icmp__2_08 = $netstat3[8];
my $Icmp__2_09 = $netstat3[9];
my $Icmp__2_10 = $netstat3[10];
my $Icmp__2_11 = $netstat3[11];
my $Icmp__2_12 = $netstat3[12];
my $Icmp__2_13 = $netstat3[13];
my $Icmp__2_14 = $netstat3[14];
my $Icmp__2_15 = $netstat3[15];
my $Icmp__2_16 = $netstat3[16];
my $Icmp__2_17 = $netstat3[17];
my $Icmp__2_18 = $netstat3[18];
my $Icmp__2_19 = $netstat3[19];
my $Icmp__2_20 = $netstat3[20];
my $Icmp__2_21 = $netstat3[21];
my $Icmp__2_22 = $netstat3[22];
my $Icmp__2_23 = $netstat3[23];
my $Icmp__2_24 = $netstat3[24];
my $Icmp__2_25 = $netstat3[25];
my $Icmp__2_26 = $netstat3[26];
my $Icmp__2_27 = $netstat3[27];
@netstat2 = grep( /IcmpMsg: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $IcmpMs2_01 = $netstat3[1];
my $IcmpMs2_02 = $netstat3[2];
@netstat2 = grep( /Tcp: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $Tcp___2_01 = $netstat3[1];
my $Tcp___2_02 = $netstat3[2];
my $Tcp___2_03 = $netstat3[3];
my $Tcp___2_04 = $netstat3[4];
my $Tcp___2_05 = $netstat3[5];
my $Tcp___2_06 = $netstat3[6];
my $Tcp___2_07 = $netstat3[7];
my $Tcp___2_08 = $netstat3[8];
my $Tcp___2_09 = $netstat3[9];
my $Tcp___2_10 = $netstat3[10];
my $Tcp___2_11 = $netstat3[11];
my $Tcp___2_12 = $netstat3[12];
my $Tcp___2_13 = $netstat3[13];
my $Tcp___2_14 = $netstat3[14];
my $Tcp___2_15 = $netstat3[15];
@netstat2 = grep( /Udp: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $Udp___2_01 = $netstat3[1];
my $Udp___2_02 = $netstat3[2];
my $Udp___2_03 = $netstat3[3];
my $Udp___2_04 = $netstat3[4];
my $Udp___2_05 = $netstat3[5];
my $Udp___2_06 = $netstat3[6];
my $Udp___2_07 = $netstat3[7];
@netstat2 = grep( /UdpLite: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $UdpLit2_01 = $netstat3[1];
my $UdpLit2_02 = $netstat3[2];
my $UdpLit2_03 = $netstat3[3];
my $UdpLit2_04 = $netstat3[4];
my $UdpLit2_05 = $netstat3[5];
my $UdpLit2_06 = $netstat3[6];
my $UdpLit2_07 = $netstat3[7];

###################### Récupération des informaiton réseau aprés transfert NETSTAT2 ######################
@netstat1 = `cat /proc/net/netstat`;

###################### Post-traitement données brut NETSTAT2 ######################
@netstat2 = grep( /TcpExt: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $TcpExt2_01 = $netstat3[1];
my $TcpExt2_02 = $netstat3[2];
my $TcpExt2_03 = $netstat3[3];
my $TcpExt2_04 = $netstat3[4];
my $TcpExt2_05 = $netstat3[5];
my $TcpExt2_06 = $netstat3[6];
my $TcpExt2_07 = $netstat3[7];
my $TcpExt2_08 = $netstat3[8];
my $TcpExt2_09 = $netstat3[9];
my $TcpExt2_10 = $netstat3[10];
my $TcpExt2_11 = $netstat3[11];
my $TcpExt2_12 = $netstat3[12];
my $TcpExt2_13 = $netstat3[13];
my $TcpExt2_14 = $netstat3[14];
my $TcpExt2_15 = $netstat3[15];
my $TcpExt2_16 = $netstat3[16];
my $TcpExt2_17 = $netstat3[17];
my $TcpExt2_18 = $netstat3[18];
my $TcpExt2_19 = $netstat3[19];
my $TcpExt2_20 = $netstat3[20];
my $TcpExt2_21 = $netstat3[21];
my $TcpExt2_22 = $netstat3[22];
my $TcpExt2_23 = $netstat3[23];
my $TcpExt2_24 = $netstat3[24];
my $TcpExt2_25 = $netstat3[25];
my $TcpExt2_26 = $netstat3[26];
my $TcpExt2_27 = $netstat3[27];
my $TcpExt2_28 = $netstat3[28];
my $TcpExt2_29 = $netstat3[29];
my $TcpExt2_30 = $netstat3[30];
my $TcpExt2_31 = $netstat3[31];
my $TcpExt2_32 = $netstat3[32];
my $TcpExt2_33 = $netstat3[33];
my $TcpExt2_34 = $netstat3[34];
my $TcpExt2_35 = $netstat3[35];
my $TcpExt2_36 = $netstat3[36];
my $TcpExt2_37 = $netstat3[37];
my $TcpExt2_38 = $netstat3[38];
my $TcpExt2_39 = $netstat3[39];
my $TcpExt2_40 = $netstat3[40];
my $TcpExt2_41 = $netstat3[41];
my $TcpExt2_42 = $netstat3[42];
my $TcpExt2_43 = $netstat3[43];
my $TcpExt2_44 = $netstat3[44];
my $TcpExt2_45 = $netstat3[45];
my $TcpExt2_46 = $netstat3[46];
my $TcpExt2_47 = $netstat3[47];
my $TcpExt2_48 = $netstat3[48];
my $TcpExt2_49 = $netstat3[49];
my $TcpExt2_50 = $netstat3[50];
my $TcpExt2_51 = $netstat3[51];
my $TcpExt2_52 = $netstat3[52];
my $TcpExt2_53 = $netstat3[53];
my $TcpExt2_54 = $netstat3[54];
my $TcpExt2_55 = $netstat3[55];
my $TcpExt2_56 = $netstat3[56];
my $TcpExt2_57 = $netstat3[57];
my $TcpExt2_58 = $netstat3[58];
my $TcpExt2_59 = $netstat3[59];
my $TcpExt2_60 = $netstat3[60];
my $TcpExt2_61 = $netstat3[61];
my $TcpExt2_62 = $netstat3[62];
my $TcpExt2_63 = $netstat3[63];
my $TcpExt2_64 = $netstat3[64];
my $TcpExt2_65 = $netstat3[65];
my $TcpExt2_66 = $netstat3[66];
my $TcpExt2_67 = $netstat3[67];
my $TcpExt2_68 = $netstat3[68];
my $TcpExt2_69 = $netstat3[69];
my $TcpExt2_70 = $netstat3[70];
my $TcpExt2_71 = $netstat3[71];
my $TcpExt2_72 = $netstat3[72];
my $TcpExt2_73 = $netstat3[73];
my $TcpExt2_74 = $netstat3[74];
my $TcpExt2_75 = $netstat3[75];
my $TcpExt2_76 = $netstat3[76];
my $TcpExt2_77 = $netstat3[77];
my $TcpExt2_78 = $netstat3[78];
my $TcpExt2_79 = $netstat3[79];
my $TcpExt2_80 = $netstat3[80];
my $TcpExt2_81 = $netstat3[81];
my $TcpExt2_82 = $netstat3[82];
my $TcpExt2_83 = $netstat3[83];
my $TcpExt2_84 = $netstat3[84];
my $TcpExt2_85 = $netstat3[85];
my $TcpExt2_86 = $netstat3[86];
my $TcpExt2_87 = $netstat3[87];
my $TcpExt2_88 = $netstat3[88];
my $TcpExt2_89 = $netstat3[89];
my $TcpExt2_90 = $netstat3[90];
my $TcpExt2_91 = $netstat3[91];
my $TcpExt2_92 = $netstat3[92];
my $TcpExt2_93 = $netstat3[93];
my $TcpExt2_94 = $netstat3[94];
my $TcpExt2_95 = $netstat3[95];
@netstat2 = grep( /IpExt: /, @netstat1);
@netstat3 = split(/ /, $netstat2[1]);
my $Ip_Ext2_01 = $netstat3[1];
my $Ip_Ext2_02 = $netstat3[2];
my $Ip_Ext2_03 = $netstat3[3];
my $Ip_Ext2_04 = $netstat3[4];
my $Ip_Ext2_05 = $netstat3[5];
my $Ip_Ext2_06 = $netstat3[6];
my $Ip_Ext2_07 = $netstat3[7];
my $Ip_Ext2_08 = $netstat3[8];
my $Ip_Ext2_09 = $netstat3[9];
my $Ip_Ext2_10 = $netstat3[10];
my $Ip_Ext2_11 = $netstat3[11];
my $Ip_Ext2_12 = $netstat3[12];
my $Ip_Ext2_13 = $netstat3[13];
my $Ip_Ext2_14 = $netstat3[14];
my $Ip_Ext2_15 = $netstat3[15];
my $Ip_Ext2_16 = $netstat3[16];
my $Ip_Ext2_17 = $netstat3[17];

###################### Calcul de la dégradation entre SNMP1 et SNMP2 ######################
my $Ip_____01 = $Ip____2_01 - $Ip____1_01;
my $Ip_____02 = $Ip____2_02 - $Ip____1_02;
my $Ip_____03 = $Ip____2_03 - $Ip____1_03;
my $Ip_____04 = $Ip____2_04 - $Ip____1_04;
my $Ip_____05 = $Ip____2_05 - $Ip____1_05;
my $Ip_____06 = $Ip____2_06 - $Ip____1_06;
my $Ip_____07 = $Ip____2_07 - $Ip____1_07;
my $Ip_____08 = $Ip____2_08 - $Ip____1_08;
my $Ip_____09 = $Ip____2_09 - $Ip____1_09;
my $Ip_____10 = $Ip____2_10 - $Ip____1_10;
my $Ip_____11 = $Ip____2_11 - $Ip____1_11;
my $Ip_____12 = $Ip____2_12 - $Ip____1_12;
my $Ip_____13 = $Ip____2_13 - $Ip____1_13;
my $Ip_____14 = $Ip____2_14 - $Ip____1_14;
my $Ip_____15 = $Ip____2_15 - $Ip____1_15;
my $Ip_____16 = $Ip____2_16 - $Ip____1_16;
my $Ip_____17 = $Ip____2_17 - $Ip____1_17;
my $Ip_____18 = $Ip____2_18 - $Ip____1_18;
my $Ip_____19 = $Ip____2_19 - $Ip____1_19;
my $Icmp___01 = $Icmp__2_01 - $Icmp__1_01;
my $Icmp___02 = $Icmp__2_02 - $Icmp__1_02;
my $Icmp___03 = $Icmp__2_03 - $Icmp__1_03;
my $Icmp___04 = $Icmp__2_04 - $Icmp__1_04;
my $Icmp___05 = $Icmp__2_05 - $Icmp__1_05;
my $Icmp___06 = $Icmp__2_06 - $Icmp__1_06;
my $Icmp___07 = $Icmp__2_07 - $Icmp__1_07;
my $Icmp___08 = $Icmp__2_08 - $Icmp__1_08;
my $Icmp___09 = $Icmp__2_09 - $Icmp__1_09;
my $Icmp___10 = $Icmp__2_10 - $Icmp__1_10;
my $Icmp___11 = $Icmp__2_11 - $Icmp__1_11;
my $Icmp___12 = $Icmp__2_12 - $Icmp__1_12;
my $Icmp___13 = $Icmp__2_13 - $Icmp__1_13;
my $Icmp___14 = $Icmp__2_14 - $Icmp__1_14;
my $Icmp___15 = $Icmp__2_15 - $Icmp__1_15;
my $Icmp___16 = $Icmp__2_16 - $Icmp__1_16;
my $Icmp___17 = $Icmp__2_17 - $Icmp__1_17;
my $Icmp___18 = $Icmp__2_18 - $Icmp__1_18;
my $Icmp___19 = $Icmp__2_19 - $Icmp__1_19;
my $Icmp___20 = $Icmp__2_20 - $Icmp__1_20;
my $Icmp___21 = $Icmp__2_21 - $Icmp__1_21;
my $Icmp___22 = $Icmp__2_22 - $Icmp__1_22;
my $Icmp___23 = $Icmp__2_23 - $Icmp__1_23;
my $Icmp___24 = $Icmp__2_24 - $Icmp__1_24;
my $Icmp___25 = $Icmp__2_25 - $Icmp__1_25;
my $Icmp___26 = $Icmp__2_26 - $Icmp__1_26;
my $Icmp___27 = $Icmp__2_27 - $Icmp__1_27;
my $IcmpMs_01 = $IcmpMs2_01 - $IcmpMs1_01;
my $IcmpMs_02 = $IcmpMs2_02 - $IcmpMs1_02;
my $Tcp____01 = $Tcp___2_01 - $Tcp___1_01;
my $Tcp____02 = $Tcp___2_02 - $Tcp___1_02;
my $Tcp____03 = $Tcp___2_03 - $Tcp___1_03;
my $Tcp____04 = $Tcp___2_04 - $Tcp___1_04;
my $Tcp____05 = $Tcp___2_05 - $Tcp___1_05;
my $Tcp____06 = $Tcp___2_06 - $Tcp___1_06;
my $Tcp____07 = $Tcp___2_07 - $Tcp___1_07;
my $Tcp____08 = $Tcp___2_08 - $Tcp___1_08;
my $Tcp____09 = $Tcp___2_09 - $Tcp___1_09;
my $Tcp____10 = $Tcp___2_10 - $Tcp___1_10;
my $Tcp____11 = $Tcp___2_11 - $Tcp___1_11;
my $Tcp____12 = $Tcp___2_12 - $Tcp___1_12;
my $Tcp____13 = $Tcp___2_13 - $Tcp___1_13;
my $Tcp____14 = $Tcp___2_14 - $Tcp___1_14;
my $Tcp____15 = $Tcp___2_15 - $Tcp___1_15;
my $Udp____01 = $Udp___2_01 - $Udp___1_01;
my $Udp____02 = $Udp___2_02 - $Udp___1_02;
my $Udp____03 = $Udp___2_03 - $Udp___1_03;
my $Udp____04 = $Udp___2_04 - $Udp___1_04;
my $Udp____05 = $Udp___2_05 - $Udp___1_05;
my $Udp____06 = $Udp___2_06 - $Udp___1_06;
my $Udp____07 = $Udp___2_07 - $Udp___1_07;
my $UdpLit_01 = $UdpLit2_01 - $UdpLit1_01;
my $UdpLit_02 = $UdpLit2_02 - $UdpLit1_02;
my $UdpLit_03 = $UdpLit2_03 - $UdpLit1_03;
my $UdpLit_04 = $UdpLit2_04 - $UdpLit1_04;
my $UdpLit_05 = $UdpLit2_05 - $UdpLit1_05;
my $UdpLit_06 = $UdpLit2_06 - $UdpLit1_06;
my $UdpLit_07 = $UdpLit2_07 - $UdpLit1_07;

###################### Calcul de la dégradation entre NETSTAT1 et NETSTAT2 ######################
my $TcpExt_01 = $TcpExt2_01 - $TcpExt1_01;
my $TcpExt_02 = $TcpExt2_02 - $TcpExt1_02;
my $TcpExt_03 = $TcpExt2_03 - $TcpExt1_03;
my $TcpExt_04 = $TcpExt2_04 - $TcpExt1_04;
my $TcpExt_05 = $TcpExt2_05 - $TcpExt1_05;
my $TcpExt_06 = $TcpExt2_06 - $TcpExt1_06;
my $TcpExt_07 = $TcpExt2_07 - $TcpExt1_07;
my $TcpExt_08 = $TcpExt2_08 - $TcpExt1_08;
my $TcpExt_09 = $TcpExt2_09 - $TcpExt1_09;
my $TcpExt_10 = $TcpExt2_10 - $TcpExt1_10;
my $TcpExt_11 = $TcpExt2_11 - $TcpExt1_11;
my $TcpExt_12 = $TcpExt2_12 - $TcpExt1_12;
my $TcpExt_13 = $TcpExt2_13 - $TcpExt1_13;
my $TcpExt_14 = $TcpExt2_14 - $TcpExt1_14;
my $TcpExt_15 = $TcpExt2_15 - $TcpExt1_15;
my $TcpExt_16 = $TcpExt2_16 - $TcpExt1_16;
my $TcpExt_17 = $TcpExt2_17 - $TcpExt1_17;
my $TcpExt_18 = $TcpExt2_18 - $TcpExt1_18;
my $TcpExt_19 = $TcpExt2_19 - $TcpExt1_19;
my $TcpExt_20 = $TcpExt2_20 - $TcpExt1_20;
my $TcpExt_21 = $TcpExt2_21 - $TcpExt1_21;
my $TcpExt_22 = $TcpExt2_22 - $TcpExt1_22;
my $TcpExt_23 = $TcpExt2_23 - $TcpExt1_23;
my $TcpExt_24 = $TcpExt2_24 - $TcpExt1_24;
my $TcpExt_25 = $TcpExt2_25 - $TcpExt1_25;
my $TcpExt_26 = $TcpExt2_26 - $TcpExt1_26;
my $TcpExt_27 = $TcpExt2_27 - $TcpExt1_27;
my $TcpExt_28 = $TcpExt2_28 - $TcpExt1_28;
my $TcpExt_29 = $TcpExt2_29 - $TcpExt1_29;
my $TcpExt_30 = $TcpExt2_30 - $TcpExt1_30;
my $TcpExt_31 = $TcpExt2_31 - $TcpExt1_31;
my $TcpExt_32 = $TcpExt2_32 - $TcpExt1_32;
my $TcpExt_33 = $TcpExt2_33 - $TcpExt1_33;
my $TcpExt_34 = $TcpExt2_34 - $TcpExt1_34;
my $TcpExt_35 = $TcpExt2_35 - $TcpExt1_35;
my $TcpExt_36 = $TcpExt2_36 - $TcpExt1_36;
my $TcpExt_37 = $TcpExt2_37 - $TcpExt1_37;
my $TcpExt_38 = $TcpExt2_38 - $TcpExt1_38;
my $TcpExt_39 = $TcpExt2_39 - $TcpExt1_39;
my $TcpExt_40 = $TcpExt2_40 - $TcpExt1_40;
my $TcpExt_41 = $TcpExt2_41 - $TcpExt1_41;
my $TcpExt_42 = $TcpExt2_42 - $TcpExt1_42;
my $TcpExt_43 = $TcpExt2_43 - $TcpExt1_43;
my $TcpExt_44 = $TcpExt2_44 - $TcpExt1_44;
my $TcpExt_45 = $TcpExt2_45 - $TcpExt1_45;
my $TcpExt_46 = $TcpExt2_46 - $TcpExt1_46;
my $TcpExt_47 = $TcpExt2_47 - $TcpExt1_47;
my $TcpExt_48 = $TcpExt2_48 - $TcpExt1_48;
my $TcpExt_49 = $TcpExt2_49 - $TcpExt1_49;
my $TcpExt_50 = $TcpExt2_50 - $TcpExt1_50;
my $TcpExt_51 = $TcpExt2_51 - $TcpExt1_51;
my $TcpExt_52 = $TcpExt2_52 - $TcpExt1_52;
my $TcpExt_53 = $TcpExt2_53 - $TcpExt1_53;
my $TcpExt_54 = $TcpExt2_54 - $TcpExt1_54;
my $TcpExt_55 = $TcpExt2_55 - $TcpExt1_55;
my $TcpExt_56 = $TcpExt2_56 - $TcpExt1_56;
my $TcpExt_57 = $TcpExt2_57 - $TcpExt1_57;
my $TcpExt_58 = $TcpExt2_58 - $TcpExt1_58;
my $TcpExt_59 = $TcpExt2_59 - $TcpExt1_59;
my $TcpExt_60 = $TcpExt2_60 - $TcpExt1_60;
my $TcpExt_61 = $TcpExt2_61 - $TcpExt1_61;
my $TcpExt_62 = $TcpExt2_62 - $TcpExt1_62;
my $TcpExt_63 = $TcpExt2_63 - $TcpExt1_63;
my $TcpExt_64 = $TcpExt2_64 - $TcpExt1_64;
my $TcpExt_65 = $TcpExt2_65 - $TcpExt1_65;
my $TcpExt_66 = $TcpExt2_66 - $TcpExt1_66;
my $TcpExt_67 = $TcpExt2_67 - $TcpExt1_67;
my $TcpExt_68 = $TcpExt2_68 - $TcpExt1_68;
my $TcpExt_69 = $TcpExt2_69 - $TcpExt1_69;
my $TcpExt_70 = $TcpExt2_70 - $TcpExt1_70;
my $TcpExt_71 = $TcpExt2_71 - $TcpExt1_71;
my $TcpExt_72 = $TcpExt2_72 - $TcpExt1_72;
my $TcpExt_73 = $TcpExt2_73 - $TcpExt1_73;
my $TcpExt_74 = $TcpExt2_74 - $TcpExt1_74;
my $TcpExt_75 = $TcpExt2_75 - $TcpExt1_75;
my $TcpExt_76 = $TcpExt2_76 - $TcpExt1_76;
my $TcpExt_77 = $TcpExt2_77 - $TcpExt1_77;
my $TcpExt_78 = $TcpExt2_78 - $TcpExt1_78;
my $TcpExt_79 = $TcpExt2_79 - $TcpExt1_79;
my $TcpExt_80 = $TcpExt2_80 - $TcpExt1_80;
my $TcpExt_81 = $TcpExt2_81 - $TcpExt1_81;
my $TcpExt_82 = $TcpExt2_82 - $TcpExt1_82;
my $TcpExt_83 = $TcpExt2_83 - $TcpExt1_83;
my $TcpExt_84 = $TcpExt2_84 - $TcpExt1_84;
my $TcpExt_85 = $TcpExt2_85 - $TcpExt1_85;
my $TcpExt_86 = $TcpExt2_86 - $TcpExt1_86;
my $TcpExt_87 = $TcpExt2_87 - $TcpExt1_87;
my $TcpExt_88 = $TcpExt2_88 - $TcpExt1_88;
my $TcpExt_89 = $TcpExt2_89 - $TcpExt1_89;
my $TcpExt_90 = $TcpExt2_90 - $TcpExt1_90;
my $TcpExt_91 = $TcpExt2_91 - $TcpExt1_91;
my $TcpExt_92 = $TcpExt2_92 - $TcpExt1_92;
my $TcpExt_93 = $TcpExt2_93 - $TcpExt1_93;
my $TcpExt_94 = $TcpExt2_94 - $TcpExt1_94;
my $TcpExt_95 = $TcpExt2_95 - $TcpExt1_95;
my $Ip_Ext_01 = $Ip_Ext2_01 - $Ip_Ext1_01;
my $Ip_Ext_02 = $Ip_Ext2_02 - $Ip_Ext1_02;
my $Ip_Ext_03 = $Ip_Ext2_03 - $Ip_Ext1_03;
my $Ip_Ext_04 = $Ip_Ext2_04 - $Ip_Ext1_04;
my $Ip_Ext_05 = $Ip_Ext2_05 - $Ip_Ext1_05;
my $Ip_Ext_06 = $Ip_Ext2_06 - $Ip_Ext1_06;
my $Ip_Ext_07 = $Ip_Ext2_07 - $Ip_Ext1_07;
my $Ip_Ext_08 = $Ip_Ext2_08 - $Ip_Ext1_08;
my $Ip_Ext_09 = $Ip_Ext2_09 - $Ip_Ext1_09;
my $Ip_Ext_10 = $Ip_Ext2_10 - $Ip_Ext1_10;
my $Ip_Ext_11 = $Ip_Ext2_11 - $Ip_Ext1_11;
my $Ip_Ext_12 = $Ip_Ext2_12 - $Ip_Ext1_12;
my $Ip_Ext_13 = $Ip_Ext2_13 - $Ip_Ext1_13;
my $Ip_Ext_14 = $Ip_Ext2_14 - $Ip_Ext1_14;
my $Ip_Ext_15 = $Ip_Ext2_15 - $Ip_Ext1_15;
my $Ip_Ext_16 = $Ip_Ext2_16 - $Ip_Ext1_16;
my $Ip_Ext_17 = $Ip_Ext2_17 - $Ip_Ext1_17;

###################### Post-traitelment données brut CURL ######################
my @curl2 = split(/-/, $curl1[0]);

##### speed_download
$curl2[0] =~ s/,/\./; # remplacer la 1ére virgule par un point
my $debit_tout_inclus = 8 * $curl2[0] /1000000;

##### DNS
$curl2[1] =~ s/,/\./; # remplacer la 1ére virgule par un point
my $dns = 1000 * $curl2[1];

##### time_connect (inclus : DNS)
$curl2[2] =~ s/,/\./; # remplacer la 1ére virgule par un point
my $dns_time_connect = 1000 * $curl2[2];

##### time_starttransfer (inclus : DNS + time_connect)
$curl2[3] =~ s/,/\./; # remplacer la 1ére virgule par un point
my $dns_ping_start = 1000 * $curl2[3];

##### time_total (inclus : DNS + time_connect + time_starttransfer)
$curl2[4] =~ s/,/\./; # remplacer la 1ére virgule par un point
my $time_total = 1000 * $curl2[4];

##### size_download
my $taille = $curl2[5] /1000000;

##### calculs
my $ping_tcp = $dns_time_connect - $dns;
my $start_transfer = $dns_ping_start - $dns_time_connect;
my $temps_download = $time_total - $dns_ping_start;

###################### Calcul du débit utile : Si division par 0, on quitte proprement ######################
if ("$temps_download" eq "0") {
	if("$type_test" eq "download") {
		close LOG; die ("Erreur, le serveur $serveur_url ne semble pas répondre\n");
	}
	if("$type_test" eq "upload") {
		close LOG; die ("Erreur, le fichier indiqué $fichier est vide ou le serveur $serveur_url ne répond pas en upload\n");
	}
}
my $debit_utile = 8000 * $taille / $temps_download;

###################### Sortie texte vers le fichier de LOG ######################
print LOG ("#####################################################################################\n");
print LOG ("###################### Résultats du test du $Date à $Heure\n");
if("$type_test" eq "download") {
	print LOG ("###################### Téléchargement d'un fichier de $taille Mo en IPv$serveur_proto\n");
}
if("$type_test" eq "upload") {
	print LOG ("###################### Upload d'un fichier de $taille Mo (avec HTTP POST) en IPv$serveur_proto\n");
}
print LOG ("#####################################################################################\n");
print LOG ("Débit moyen utile (DNS + SYN exclu): $debit_utile Mb/s\n");
print LOG ("Débit moyen réel  (temps1+t2+t3+t4): $debit_tout_inclus Mb/s\n");
print LOG ("Temps1: résolution DNS             : $dns ms\n");
print LOG ("Temps2: connexion [SYN]+[SYN ACK]  : $ping_tcp ms\n");
print LOG ("Temps3: entre [SYN ACK] et 1er paq : $start_transfer ms\n");
print LOG ("Somme de Temps1 + Temps2 + Temps3  : $dns_ping_start ms\n");
print LOG ("Temps4: temps de transfert utile   : $temps_download ms\n");
print LOG ("Taille utile transférée            : $taille Mo\n");
if("$type_test" eq "upload") {
	print LOG ("Fichier local utilisé pour l'upload: $fichier\n");
}
print LOG ("###################### Statistiques TCP ######################\n");
if ("$Tcp____05" ne "0") {print LOG ("Tcp    05 ActiveOpens              : $Tcp____05 connexions actives ouvertes\n"); }
if ("$Tcp____06" ne "0") {print LOG ("Tcp    06 PassiveOpens             : $Tcp____06 connexions passives ouvertes\n"); }
if ("$Tcp____10" ne "0") {print LOG ("Tcp    10 InSegs                   : $Tcp____10 segments TCP reçus\n"); }
if ("$Tcp____11" ne "0") {print LOG ("Tcp    11 OutSegs                  : $Tcp____11 segments TCP envoyés\n"); }
if ("$TcpExt_26" ne "0") {print LOG ("TcpExt 26 TCPHPHits                : $TcpExt_26 en-têtes de paquets TCP prédits\n"); }
if ("$TcpExt_28" ne "0") {print LOG ("TcpExt 28 TCPPureAcks              : $TcpExt_28 acquittement reçu sans données utiles\n"); }
if ("$TcpExt_29" ne "0") {print LOG ("TcpExt 29 TCPHPAcks                : $TcpExt_29 accusés de réception prédits\n"); }
if ("$TcpExt_83" ne "0") {print LOG ("TcpExt 83 TCPRcvCoalesce           : $TcpExt_83\n"); }

print LOG ("###################### Statistiques UDP / ICMP ######################\n");
if ("$Udp____01" ne "0") {print LOG ("Udp    01 InDatagrams              : $Udp____01 paquets UDP reçus\n"); }
if ("$Udp____04" ne "0") {print LOG ("Udp    04 OutDatagrams             : $Udp____04 paquets uDP envoyés\n"); }
if ("$UdpLit_01" ne "0") {print LOG ("UdpLit 01 InDatagrams              : $UdpLit_01 paquets UDP Lite reçus\n"); }
if ("$UdpLit_04" ne "0") {print LOG ("UdpLit 04 OutDatagrams             : $UdpLit_04 paquets UDP Lite envoyés\n"); }
if ("$Icmp___01" ne "0") {print LOG ("Icmp   01 InMsgs                   : $Icmp___01 messages ICMP reçus\n"); }
if ("$Icmp___09" ne "0") {print LOG ("Icmp   09 InEchos                  : $Icmp___09 requêtes d'écho reçus\n"); }
if ("$Icmp___10" ne "0") {print LOG ("Icmp   10 InEchoReps               : $Icmp___10 réponses à écho reçus\n"); }
if ("$Icmp___15" ne "0") {print LOG ("Icmp   15 OutMsgs                  : $Icmp___15 messages ICMP envoyés\n"); }
if ("$Icmp___22" ne "0") {print LOG ("Icmp   22 OutEchos                 : $Icmp___22 requêtes d'écho envoyés\n"); }
if ("$Icmp___23" ne "0") {print LOG ("Icmp   23 OutEchoReps              : $Icmp___23 réponses à écho envoyés\n"); }
if ("$IcmpMs_01" ne "0") {print LOG ("IcmpMs 01 InType3                  : $IcmpMs_01 messages ICMP reçus de type3\n"); }
if ("$IcmpMs_02" ne "0") {print LOG ("IcmpMs 02 OutType3                 : $IcmpMs_02 messages ICMP envoyés de type3\n"); }

print LOG ("###################### Statistiques IP ######################\n");
if ("$Ip_____03" ne "0") {print LOG ("Ip     03 InReceives               : $Ip_____03 paquets reçus au total\n"); }
if ("$Ip_____09" ne "0") {print LOG ("Ip     09 InDelivers               : $Ip_____09 paquets entrants délivrés\n"); }
if ("$Ip_____10" ne "0") {print LOG ("Ip     10 OutRequests              : $Ip_____10 requêtes envoyées\n"); }
if ("$Ip_Ext_03" ne "0") {print LOG ("Ip Ext 03 InMcastPkts              : $Ip_Ext_03 paquets multicast reçus\n"); }
if ("$Ip_Ext_04" ne "0") {print LOG ("Ip Ext 04 OutMcastPkts             : $Ip_Ext_04 paquets multicast envoyés\n"); }
if ("$Ip_Ext_05" ne "0") {print LOG ("Ip Ext 05 InBcastPkts              : $Ip_Ext_05 paquets broadcast reçus\n"); }
if ("$Ip_Ext_06" ne "0") {print LOG ("Ip Ext 06 OutBcastPkts             : $Ip_Ext_06 paquets broadcast envoyés\n"); }
if ("$Ip_Ext_07" ne "0") {print LOG ("Ip Ext 07 InOctets                 : $Ip_Ext_07 octets reçus\n"); }
if ("$Ip_Ext_08" ne "0") {print LOG ("Ip Ext 08 OutOctets                : $Ip_Ext_08 octets envoyées\n"); }
if ("$Ip_Ext_09" ne "0") {print LOG ("Ip Ext 09 InMcastOctets            : $Ip_Ext_09 octets multicast reçus\n"); }
if ("$Ip_Ext_10" ne "0") {print LOG ("Ip Ext 10 OutMcastOctets           : $Ip_Ext_10 octets multicast envoyés\n"); }
if ("$Ip_Ext_11" ne "0") {print LOG ("Ip Ext 11 InBcastOctets            : $Ip_Ext_11 octets broadcast reçus\n"); }
if ("$Ip_Ext_12" ne "0") {print LOG ("Ip Ext 12 OutBcastOctets           : $Ip_Ext_12 octets broadcast envoyés\n"); }
if ("$Ip_Ext_14" ne "0") {print LOG ("Ip Ext 14 InNoECTPkts              : $Ip_Ext_14\n"); }

###################### Calcul du % de perte de paquets: Si division par 0, on quitte proprement ######################
if("$type_test" eq "download") {
	if ("$Tcp____10" eq "0") {
		close LOG; die ("Erreur, le serveur $serveur_url ne semble pas répondre\n");
	}
	print LOG ("###################### Anomalies pendant le transfert download ######################\n");
	$perte = $TcpExt_84 * 100 / $Tcp____10;
	print LOG ("Paquets acquités par un [Dup ACK]  : $perte % (si >0, signifie la présence de pertes de paquets)\n");
}
if("$type_test" eq "upload") {
	if ("$Tcp____11" eq "0") {
		close LOG; die ("Erreur, le fichier indiqué $fichier est vide ou le serveur $serveur_url ne répond pas en upload\n");
	}
	print LOG ("###################### Anomalies pendant le transfert upload ######################\n");
	$perte = $Tcp____12 * 100 / $Tcp____11;
	print LOG ("Pourcentage de paquets retransmis  : $perte % (c'est le pourcentage de paquets perdus)\n");
}
if ("$Tcp____01" ne "0") {$anomalie++; print LOG ("Tcp    01 RtoAlgorithm (fixe 1 ?)  : $Tcp____01\n"); }
if ("$Tcp____02" ne "0") {$anomalie++; print LOG ("Tcp    02 RtoMin (fixe 200 ?)      : $Tcp____02\n"); }
if ("$Tcp____03" ne "0") {$anomalie++; print LOG ("Tcp    03 RtoMax (fixe 120000 ?)   : $Tcp____03\n"); }
if ("$Tcp____04" ne "0") {$anomalie++; print LOG ("Tcp    04 MaxConn(fixe -1 ?)       : $Tcp____04\n"); }
if ("$Tcp____07" ne "0") {$anomalie++; print LOG ("Tcp    07 AttemptFails             : $Tcp____07 tentatives de connexion échouées\n"); }
if ("$Tcp____08" ne "0") {$anomalie++; print LOG ("Tcp    08 EstabResets              : $Tcp____08 Réinitialisation de la connection\n"); }
if ("$Tcp____09" ne "0") {$anomalie++; print LOG ("Tcp    09 CurrEstab                : $Tcp____09\n"); }
if ("$Tcp____12" ne "0") {$anomalie++; print LOG ("Tcp    12 RetransSegs (upload only): $Tcp____12 paquets TCP perdus en upload\n"); }
if ("$Tcp____13" ne "0") {$anomalie++; print LOG ("Tcp    13 InErrs                   : $Tcp____13 mauvais segments reçus\n"); }
if ("$Tcp____14" ne "0") {$anomalie++; print LOG ("Tcp    14 OutRsts                  : $Tcp____14 réinitailisations envoyées\n"); }
if ("$Tcp____15" ne "0") {$anomalie++; print LOG ("Tcp    15 InCsumErrors             : $Tcp____15\n"); }
if ("$TcpExt_01" ne "0") {$anomalie++; print LOG ("TcpExt 01 SyncookiesSent           : $TcpExt_01\n"); }
if ("$TcpExt_02" ne "0") {$anomalie++; print LOG ("TcpExt 02 SyncookiesRecv           : $TcpExt_02\n"); }
if ("$TcpExt_03" ne "0") {$anomalie++; print LOG ("TcpExt 03 SyncookiesFailed         : $TcpExt_03\n"); }
if ("$TcpExt_04" ne "0") {$anomalie++; print LOG ("TcpExt 04 EmbryonicRsts            : $TcpExt_04\n"); }
if ("$TcpExt_05" ne "0") {$anomalie++; print LOG ("TcpExt 05 PruneCalled              : $TcpExt_05\n"); }
if ("$TcpExt_06" ne "0") {$anomalie++; print LOG ("TcpExt 06 RcvPruned                : $TcpExt_06\n"); }
if ("$TcpExt_07" ne "0") {$anomalie++; print LOG ("TcpExt 07 OfoPruned                : $TcpExt_07\n"); }
if ("$TcpExt_08" ne "0") {$anomalie++; print LOG ("TcpExt 08 OutOfWindowIcmps         : $TcpExt_08\n"); }
if ("$TcpExt_09" ne "0") {$anomalie++; print LOG ("TcpExt 09 LockDroppedIcmps         : $TcpExt_09\n"); }
if ("$TcpExt_10" ne "0") {$anomalie++; print LOG ("TcpExt 10 ArpFilter                : $TcpExt_10\n"); }
if ("$TcpExt_11" ne "0") {$anomalie++; print LOG ("TcpExt 11 TW (TW = Time Wait)      : $TcpExt_11 TCP sockets finished time wait\n"); }
if ("$TcpExt_12" ne "0") {$anomalie++; print LOG ("TcpExt 12 TWRecycled (TW=Time Wait): $TcpExt_12 connexion TCP\n"); }
if ("$TcpExt_13" ne "0") {$anomalie++; print LOG ("TcpExt 13 TWKilled (TW = Time Wait): $TcpExt_13 connexion TCP\n"); }
if ("$TcpExt_14" ne "0") {$anomalie++; print LOG ("TcpExt 14 PAWSPassive              : $TcpExt_14\n"); }
if ("$TcpExt_15" ne "0") {$anomalie++; print LOG ("TcpExt 15 PAWSActive               : $TcpExt_15\n"); }
if ("$TcpExt_16" ne "0") {$anomalie++; print LOG ("TcpExt 16 PAWSEstab                : $TcpExt_16\n"); }
if ("$TcpExt_17" ne "0") {$anomalie++; print LOG ("TcpExt 17 DelayedACKs              : $TcpExt_17\n"); }
if ("$TcpExt_18" ne "0") {$anomalie++; print LOG ("TcpExt 18 DelayedACKLocked         : $TcpExt_18\n"); }
if ("$TcpExt_19" ne "0") {$anomalie++; print LOG ("TcpExt 19 DelayedACKLost           : $TcpExt_19\n"); }
if ("$TcpExt_20" ne "0") {$anomalie++; print LOG ("TcpExt 20 ListenOverflows          : $TcpExt_20\n"); }
if ("$TcpExt_21" ne "0") {$anomalie++; print LOG ("TcpExt 21 ListenDrops              : $TcpExt_21\n"); }
if ("$TcpExt_22" ne "0") {$anomalie++; print LOG ("TcpExt 22 TCPPrequeued             : $TcpExt_22\n"); }
if ("$TcpExt_23" ne "0") {$anomalie++; print LOG ("TcpExt 23 TCPDirectCopyFromBacklog : $TcpExt_23\n"); }
if ("$TcpExt_24" ne "0") {$anomalie++; print LOG ("TcpExt 24 TCPDirectCopyFromPrequeue: $TcpExt_24\n"); }
if ("$TcpExt_25" ne "0") {$anomalie++; print LOG ("TcpExt 25 TCPPrequeueDropped       : $TcpExt_25\n"); }
if ("$TcpExt_27" ne "0") {$anomalie++; print LOG ("TcpExt 27 TCPHPHitsToUser          : $TcpExt_27\n"); }
if ("$TcpExt_30" ne "0") {$anomalie++; print LOG ("TcpExt 30 TCPRenoRecovery          : $TcpExt_30\n"); }
if ("$TcpExt_31" ne "0") {$anomalie++; print LOG ("TcpExt 31 TCPSackRecovery          : $TcpExt_31\n"); }
if ("$TcpExt_32" ne "0") {$anomalie++; print LOG ("TcpExt 32 TCPSACKReneging          : $TcpExt_32\n"); }
if ("$TcpExt_33" ne "0") {$anomalie++; print LOG ("TcpExt 33 TCPFACKReorder           : $TcpExt_33\n"); }
if ("$TcpExt_34" ne "0") {$anomalie++; print LOG ("TcpExt 34 TCPSACKReorder           : $TcpExt_34\n"); }
if ("$TcpExt_35" ne "0") {$anomalie++; print LOG ("TcpExt 35 TCPRenoReorder           : $TcpExt_35\n"); }
if ("$TcpExt_36" ne "0") {$anomalie++; print LOG ("TcpExt 36 TCPTSReorder             : $TcpExt_36\n"); }
if ("$TcpExt_37" ne "0") {$anomalie++; print LOG ("TcpExt 37 TCPFullUndo              : $TcpExt_37\n"); }
if ("$TcpExt_38" ne "0") {$anomalie++; print LOG ("TcpExt 38 TCPPartialUndo           : $TcpExt_38\n"); }
if ("$TcpExt_39" ne "0") {$anomalie++; print LOG ("TcpExt 39 TCPDSACKUndo             : $TcpExt_39\n"); }
if ("$TcpExt_40" ne "0") {$anomalie++; print LOG ("TcpExt 40 TCPLossUndo              : $TcpExt_40\n"); }
if ("$TcpExt_41" ne "0") {$anomalie++; print LOG ("TcpExt 41 TCPLostRetransmit        : $TcpExt_41\n"); }
if ("$TcpExt_42" ne "0") {$anomalie++; print LOG ("TcpExt 42 TCPRenoFailures          : $TcpExt_42\n"); }
if ("$TcpExt_43" ne "0") {$anomalie++; print LOG ("TcpExt 43 TCPSackFailures          : $TcpExt_43\n"); }
if ("$TcpExt_44" ne "0") {$anomalie++; print LOG ("TcpExt 44 TCPLossFailures          : $TcpExt_44\n"); }
if ("$TcpExt_45" ne "0") {$anomalie++; print LOG ("TcpExt 45 TCPFastRetrans           : $TcpExt_45\n"); }
if ("$TcpExt_46" ne "0") {$anomalie++; print LOG ("TcpExt 46 TCPForwardRetrans        : $TcpExt_46\n"); }
if ("$TcpExt_47" ne "0") {$anomalie++; print LOG ("TcpExt 47 TCPSlowStartRetrans      : $TcpExt_47\n"); }
if ("$TcpExt_48" ne "0") {$anomalie++; print LOG ("TcpExt 48 TCPTimeouts              : $TcpExt_48\n"); }
if ("$TcpExt_49" ne "0") {$anomalie++; print LOG ("TcpExt 49 TCPLossProbes            : $TcpExt_49\n"); }
if ("$TcpExt_50" ne "0") {$anomalie++; print LOG ("TcpExt 50 TCPLossProbeRecovery     : $TcpExt_50\n"); }
if ("$TcpExt_51" ne "0") {$anomalie++; print LOG ("TcpExt 51 TCPRenoRecoveryFail      : $TcpExt_51\n"); }
if ("$TcpExt_52" ne "0") {$anomalie++; print LOG ("TcpExt 52 TCPSackRecoveryFail      : $TcpExt_52\n"); }
if ("$TcpExt_53" ne "0") {$anomalie++; print LOG ("TcpExt 53 TCPSchedulerFailed       : $TcpExt_53\n"); }
if ("$TcpExt_54" ne "0") {$anomalie++; print LOG ("TcpExt 54 TCPRcvCollapsed          : $TcpExt_54\n"); }
if ("$TcpExt_55" ne "0") {$anomalie++; print LOG ("TcpExt 55 TCPDSACKOldSent          : $TcpExt_55\n"); }
if ("$TcpExt_56" ne "0") {$anomalie++; print LOG ("TcpExt 56 TCPDSACKOfoSent          : $TcpExt_56\n"); }
if ("$TcpExt_57" ne "0") {$anomalie++; print LOG ("TcpExt 57 TCPDSACKRecv             : $TcpExt_57\n"); }
if ("$TcpExt_58" ne "0") {$anomalie++; print LOG ("TcpExt 58 TCPDSACKOfoRecv          : $TcpExt_58\n"); }
if ("$TcpExt_59" ne "0") {$anomalie++; print LOG ("TcpExt 59 TCPAbortOnData           : $TcpExt_59\n"); }
if ("$TcpExt_60" ne "0") {$anomalie++; print LOG ("TcpExt 60 TCPAbortOnClose          : $TcpExt_60\n"); }
if ("$TcpExt_61" ne "0") {$anomalie++; print LOG ("TcpExt 61 TCPAbortOnMemory         : $TcpExt_61\n"); }
if ("$TcpExt_62" ne "0") {$anomalie++; print LOG ("TcpExt 62 TCPAbortOnTimeout        : $TcpExt_62\n"); }
if ("$TcpExt_63" ne "0") {$anomalie++; print LOG ("TcpExt 63 TCPAbortOnLinger         : $TcpExt_63\n"); }
if ("$TcpExt_64" ne "0") {$anomalie++; print LOG ("TcpExt 64 TCPAbortFailed           : $TcpExt_64\n"); }
if ("$TcpExt_65" ne "0") {$anomalie++; print LOG ("TcpExt 65 TCPMemoryPressures       : $TcpExt_65\n"); }
if ("$TcpExt_66" ne "0") {$anomalie++; print LOG ("TcpExt 66 TCPSACKDiscard           : $TcpExt_66\n"); }
if ("$TcpExt_67" ne "0") {$anomalie++; print LOG ("TcpExt 67 TCPDSACKIgnoredOld       : $TcpExt_67\n"); }
if ("$TcpExt_68" ne "0") {$anomalie++; print LOG ("TcpExt 68 TCPDSACKIgnoredNoUndo    : $TcpExt_68\n"); }
if ("$TcpExt_69" ne "0") {$anomalie++; print LOG ("TcpExt 69 TCPSpuriousRTOs          : $TcpExt_69\n"); }
if ("$TcpExt_70" ne "0") {$anomalie++; print LOG ("TcpExt 70 TCPMD5NotFound           : $TcpExt_70\n"); }
if ("$TcpExt_71" ne "0") {$anomalie++; print LOG ("TcpExt 71 TCPMD5Unexpected         : $TcpExt_71\n"); }
if ("$TcpExt_72" ne "0") {$anomalie++; print LOG ("TcpExt 72 TCPSackShifted           : $TcpExt_72\n"); }
if ("$TcpExt_73" ne "0") {$anomalie++; print LOG ("TcpExt 73 TCPSackMerged            : $TcpExt_73\n"); }
if ("$TcpExt_74" ne "0") {$anomalie++; print LOG ("TcpExt 74 TCPSackShiftFallback     : $TcpExt_74\n"); }
if ("$TcpExt_75" ne "0") {$anomalie++; print LOG ("TcpExt 75 TCPBacklogDrop           : $TcpExt_75\n"); }
if ("$TcpExt_76" ne "0") {$anomalie++; print LOG ("TcpExt 76 TCPMinTTLDrop            : $TcpExt_76\n"); }
if ("$TcpExt_77" ne "0") {$anomalie++; print LOG ("TcpExt 77 TCPDeferAcceptDrop       : $TcpExt_77\n"); }
if ("$TcpExt_78" ne "0") {$anomalie++; print LOG ("TcpExt 78 IPReversePathFilter      : $TcpExt_78\n"); }
if ("$TcpExt_79" ne "0") {$anomalie++; print LOG ("TcpExt 79 TCPTimeWaitOverflow      : $TcpExt_79\n"); }
if ("$TcpExt_80" ne "0") {$anomalie++; print LOG ("TcpExt 80 TCPReqQFullDoCookies     : $TcpExt_80\n"); }
if ("$TcpExt_81" ne "0") {$anomalie++; print LOG ("TcpExt 81 TCPReqQFullDrop          : $TcpExt_81\n"); }
if ("$TcpExt_82" ne "0") {$anomalie++; print LOG ("TcpExt 82 TCPRetransFail           : $TcpExt_82\n"); }
if ("$TcpExt_84" ne "0") {$anomalie++; print LOG ("TcpExt 84 TCPOFOQueue              : $TcpExt_84 paquets [TCP Dup ACK]\n"); }
if ("$TcpExt_85" ne "0") {$anomalie++; print LOG ("TcpExt 85 TCPOFODrop               : $TcpExt_85\n"); }
if ("$TcpExt_86" ne "0") {$anomalie++; print LOG ("TcpExt 86 TCPOFOMerge              : $TcpExt_86\n"); }
if ("$TcpExt_87" ne "0") {$anomalie++; print LOG ("TcpExt 87 TCPChallengeACK          : $TcpExt_87\n"); }
if ("$TcpExt_88" ne "0") {$anomalie++; print LOG ("TcpExt 88 TCPSYNChallenge          : $TcpExt_88\n"); }
if ("$TcpExt_89" ne "0") {$anomalie++; print LOG ("TcpExt 89 TCPFastOpenActive        : $TcpExt_89\n"); }
if ("$TcpExt_90" ne "0") {$anomalie++; print LOG ("TcpExt 90 TCPFastOpenPassive       : $TcpExt_90\n"); }
if ("$TcpExt_91" ne "0") {$anomalie++; print LOG ("TcpExt 91 TCPFastOpenPassiveFail   : $TcpExt_91\n"); }
if ("$TcpExt_92" ne "0") {$anomalie++; print LOG ("TcpExt 92 TCPFastOpenListenOverflow: $TcpExt_92\n"); }
if ("$TcpExt_93" ne "0") {$anomalie++; print LOG ("TcpExt 93 TCPFastOpenCookieReqd    : $TcpExt_93\n"); }
if ("$TcpExt_94" ne "0") {$anomalie++; print LOG ("TcpExt 94 TCPSpuriousRtxHostQueues : $TcpExt_94\n"); }
if ("$TcpExt_95" ne "0") {$anomalie++; print LOG ("TcpExt 95 BusyPollRxPackets        : $TcpExt_95\n"); }
if ("$Ip_____01" ne "0") {$anomalie++; print LOG ("Ip     01 Forwarding               : $Ip_____01\n"); }
if ("$Ip_____02" ne "0") {$anomalie++; print LOG ("Ip     02 DefaultTTL               : $Ip_____02\n"); }
if ("$Ip_____04" ne "0") {$anomalie++; print LOG ("Ip     04 InHdrErrors              : $Ip_____04\n"); }
if ("$Ip_____05" ne "0") {$anomalie++; print LOG ("Ip     05 InAddrErrors             : $Ip_____05\n"); }
if ("$Ip_____06" ne "0") {$anomalie++; print LOG ("Ip     06 ForwDatagrams            : $Ip_____06 paquets\n"); }
if ("$Ip_____07" ne "0") {$anomalie++; print LOG ("Ip     07 InUnknownProtos          : $Ip_____07\n"); }
if ("$Ip_____08" ne "0") {$anomalie++; print LOG ("Ip     08 InDiscards               : $Ip_____08\n"); }
if ("$Ip_____11" ne "0") {$anomalie++; print LOG ("Ip     11 OutDiscards              : $Ip_____11\n"); }
if ("$Ip_____12" ne "0") {$anomalie++; print LOG ("Ip     12 OutNoRoutes              : $Ip_____12\n"); }
if ("$Ip_____13" ne "0") {$anomalie++; print LOG ("Ip     13 ReasmTimeout             : $Ip_____13\n"); }
if ("$Ip_____14" ne "0") {$anomalie++; print LOG ("Ip     14 ReasmReqds               : $Ip_____14\n"); }
if ("$Ip_____15" ne "0") {$anomalie++; print LOG ("Ip     15 ReasmOKs                 : $Ip_____15\n"); }
if ("$Ip_____16" ne "0") {$anomalie++; print LOG ("Ip     16 ReasmFails               : $Ip_____16\n"); }
if ("$Ip_____17" ne "0") {$anomalie++; print LOG ("Ip     17 FragOKs                  : $Ip_____17\n"); }
if ("$Ip_____18" ne "0") {$anomalie++; print LOG ("Ip     18 FragFails                : $Ip_____18\n"); }
if ("$Ip_____19" ne "0") {$anomalie++; print LOG ("Ip     19 FragCreates              : $Ip_____19\n"); }
if ("$Ip_Ext_01" ne "0") {$anomalie++; print LOG ("Ip Ext 01 InNoRoutes               : $Ip_Ext_01 paquets\n"); }
if ("$Ip_Ext_02" ne "0") {$anomalie++; print LOG ("Ip Ext 02 InTruncatedPkts          : $Ip_Ext_02 paquets\n"); }
if ("$Ip_Ext_13" ne "0") {$anomalie++; print LOG ("Ip Ext 13 InCsumErrors             : $Ip_Ext_13 paquets\n"); }
if ("$Ip_Ext_15" ne "0") {$anomalie++; print LOG ("Ip Ext 15 InECT1Pkts               : $Ip_Ext_15 paquets\n"); }
if ("$Ip_Ext_16" ne "0") {$anomalie++; print LOG ("Ip Ext 16 InECT0Pkts               : $Ip_Ext_16 paquets\n"); }
if ("$Ip_Ext_17" ne "0") {$anomalie++; print LOG ("Ip Ext 17 InCEPkts                 : $Ip_Ext_17 paquets\n"); }
if ("$Udp____02" ne "0") {$anomalie++; print LOG ("Udp    02 NoPorts                  : $Udp____02 paquets UDP\n"); }
if ("$Udp____03" ne "0") {$anomalie++; print LOG ("Udp    03 InErrors                 : $Udp____03 paquets UDP\n"); }
if ("$Udp____05" ne "0") {$anomalie++; print LOG ("Udp    05 RcvbufErrors             : $Udp____05\n"); }
if ("$Udp____06" ne "0") {$anomalie++; print LOG ("Udp    06 SndbufErrors             : $Udp____06\n"); }
if ("$Udp____07" ne "0") {$anomalie++; print LOG ("Udp    07 InCsumErrors             : $Udp____07 paquets UDP\n"); }
if ("$UdpLit_02" ne "0") {$anomalie++; print LOG ("UdpLit 02 NoPorts                  : $UdpLit_02 paquets UDP Lite\n"); }
if ("$UdpLit_03" ne "0") {$anomalie++; print LOG ("UdpLit 03 InErrors                 : $UdpLit_03 paquets UDP Lite\n"); }
if ("$UdpLit_05" ne "0") {$anomalie++; print LOG ("UdpLit 05 RcvbufErrors             : $UdpLit_05\n"); }
if ("$UdpLit_06" ne "0") {$anomalie++; print LOG ("UdpLit 06 SndbufErrors             : $UdpLit_06\n"); }
if ("$UdpLit_07" ne "0") {$anomalie++; print LOG ("UdpLit 07 InCsumErrors             : $UdpLit_07 paquets ICMP\n"); }
if ("$Icmp___02" ne "0") {$anomalie++; print LOG ("Icmp   02 InErrors                 : $Icmp___02 paquets ICMP\n"); }
if ("$Icmp___03" ne "0") {$anomalie++; print LOG ("Icmp   03 InCsumErrors             : $Icmp___03 paquets ICMP\n"); }
if ("$Icmp___04" ne "0") {$anomalie++; print LOG ("Icmp   04 InDestUnreachs           : $Icmp___04 destination injoignable reçus\n"); }
if ("$Icmp___05" ne "0") {$anomalie++; print LOG ("Icmp   05 InTimeExcds              : $Icmp___05 temps dépassé reçus\n"); }
if ("$Icmp___06" ne "0") {$anomalie++; print LOG ("Icmp   06 InParmProbs              : $Icmp___06 paquets ICMP\n"); }
if ("$Icmp___07" ne "0") {$anomalie++; print LOG ("Icmp   07 InSrcQuenchs             : $Icmp___07 paquets ICMP\n"); }
if ("$Icmp___08" ne "0") {$anomalie++; print LOG ("Icmp   08 InRedirects              : $Icmp___08 paquets ICMP\n"); }
if ("$Icmp___11" ne "0") {$anomalie++; print LOG ("Icmp   11 InTimestamps             : $Icmp___11 paquets ICMP\n"); }
if ("$Icmp___12" ne "0") {$anomalie++; print LOG ("Icmp   12 InTimestampReps          : $Icmp___12 paquets ICMP\n"); }
if ("$Icmp___13" ne "0") {$anomalie++; print LOG ("Icmp   13 InAddrMasks              : $Icmp___13 paquets ICMP\n"); }
if ("$Icmp___14" ne "0") {$anomalie++; print LOG ("Icmp   14 InAddrMaskReps           : $Icmp___14 paquets ICMP\n"); }
if ("$Icmp___16" ne "0") {$anomalie++; print LOG ("Icmp   16 OutErrors                : $Icmp___16 paquets ICMP\n"); }
if ("$Icmp___17" ne "0") {$anomalie++; print LOG ("Icmp   17 OutDestUnreachs          : $Icmp___17 destination injoignable envoyées\n"); }
if ("$Icmp___18" ne "0") {$anomalie++; print LOG ("Icmp   18 OutTimeExcds             : $Icmp___18 temps dépassé envoyées\n"); }
if ("$Icmp___19" ne "0") {$anomalie++; print LOG ("Icmp   19 OutParmProbs             : $Icmp___19 paquets ICMP\n"); }
if ("$Icmp___20" ne "0") {$anomalie++; print LOG ("Icmp   20 OutSrcQuenchs            : $Icmp___20 paquets ICMP\n"); }
if ("$Icmp___21" ne "0") {$anomalie++; print LOG ("Icmp   21 OutRedirects             : $Icmp___21 paquets ICMP\n"); }
if ("$Icmp___24" ne "0") {$anomalie++; print LOG ("Icmp   24 OutTimestamps            : $Icmp___24 paquets ICMP\n"); }
if ("$Icmp___25" ne "0") {$anomalie++; print LOG ("Icmp   25 OutTimestampReps         : $Icmp___25 paquets ICMP\n"); }
if ("$Icmp___26" ne "0") {$anomalie++; print LOG ("Icmp   26 OutAddrMasks             : $Icmp___26 paquets ICMP\n"); }
if ("$Icmp___27" ne "0") {$anomalie++; print LOG ("Icmp   27 OutAddrMaskReps          : $Icmp___27 paquets ICMP\n"); }
$anomalie_critique = $Tcp____08 + $Tcp____13 + $Tcp____14;
print LOG ("=> Nombre d'anomalies listées      : $anomalie anomalie(s) dont $anomalie_critique critique(s)\n\n\n");
close LOG;

###################### Sortie texte simplifiée vers la console ######################

if("$type_test" eq "download") {
	print ("Téléchargement d'un fichier de $taille Mo en IPv$serveur_proto le $Date à $Heure :\n");
}
if("$type_test" eq "upload") {
	print ("Upload d'un fichier de $taille Mo (avec HTTP POST) en IPv$serveur_proto le $Date à $Heure :\n");
}
print ("Débit moyen          : $debit_utile Mb/s ($debit_tout_inclus Mb/s en incluant le temps de connexion)\n");
print ("Ping TCP             : $ping_tcp ms\n");
print ("Temps résolution DNS : $dns ms\n");
print ("Temps de connexion   : $dns_ping_start ms (inclus temps DNS)\n");
if("$type_test" eq "download") {
	print ("Paquets [TCP Dup ACK]: $perte % (si >0, signifie la présence de pertes de paquets)\n");
}
if("$type_test" eq "upload") {
	print ("Paquets perdus       : $perte %\n");
}
print ("Nombre d'anomalies   : $anomalie dont $anomalie_critique critique(s) - détails dans $LOGFILE_NAME\n\n");
