--[[ Uplink For PSP
  Game Resources definition File
  ]]
  
  
--Complete list of all Gateways

H_gateway={
{_name="ArkNOS TTG",_desc={['EN']="The standard gateway given to all rookies agents",['FR']='La Passerelle standard pour tout agent'},_cost=10000,_MaxModem = 2 ,_MaxCPU = 2 ,_MaxMemory = 100,img = Image.load('./Contents/graphics/gateway/gateway0.jpg')},
{_name="Omicron Core",_desc={['EN']="Faster gateway based on the latest Omicron core",['FR']='Passerelle rapide integrant la plus recente puce Omicron'},_cost=13000,_MaxModem = 3 ,_MaxCPU = 2 ,_MaxMemory = 200,img = Image.load('./Contents/graphics/gateway/gateway1.jpg')},
{_name="ChipTek 4356-TS",_desc={['EN']="Fast gateway,based on the latest TS processor",['FR']='Passerelle rapide integrant le dernier processeur TS'},_cost=22000,_MaxModem = 3 ,_MaxCPU = 2 ,_MaxMemory = 220,img = Image.load('./Contents/graphics/gateway/gateway2.jpg')},
{_name="Intraware X",_desc={['EN']="Fast gateway, stable for hacking stuff",['FR']='Passerelle rapide et stable pour pour le hacking'},_cost=33000,_MaxModem = 4 ,_MaxCPU = 4 ,_MaxMemory = 300,img = Image.load('./Contents/graphics/gateway/gateway3.jpg')},
{_name="Omega Extreme",_desc={['EN']='Very high standard gateway,holds on lastest Omega chipset',['FR']='Passerelle performante integrand le dernier chipset Omega'},_cost=42000,_MaxModem = 4 ,_MaxCPU = 4 ,_MaxMemory = 340,img = Image.load('./Contents/graphics/gateway/gateway4.jpg')},
{_name="Trinity Elite",_desc={['EN']="The best gateway ever, fast, and secured",['FR']='L\'ultime passerelle, rapide et securisee'},_cost=50000,_MaxModem = 6 ,_MaxCPU = 8 ,_MaxMemory = 550,img = Image.load('./Contents/graphics/gateway/gateway5.jpg')},
{_name="Trinity Prototype",_desc={['EN']='A prototype gateway, highly fast, still experimented',['FR']='Une passerelle prototype, extremement rapide'},_cost=115000,_MaxModem = 10 ,_MaxCPU = 12 ,_MaxMemory = 750,img = Image.load('./Contents/graphics/gateway/gateway6.jpg')},
}

--Complete List of all hardware upgrades (fields are name,specification,details, cost)
H_hardware = {
{_hardw="CPU",_spec="1 Ghz",_desc={['EN']="Increases CPU clock frequency",['FR']='Augmente la frequence CPU'},_price=12500,Upvalue = 1},
{_hardw="Memory",_spec="10 Gb",_desc={['EN']="Increases gateway storage space",['FR']='Augmente l\'espace de stockage'},_price=15000,Upvalue = 10},
{_hardw="Modem",_spec="1 Mb/s",_desc={['EN']="Increases Bandwidth for faster file download",['FR']='Augmente la bande passante pour des telechargements plus rapides'},_price=17500,Upvalue = 1},
}

--Complete list of available servers
H_servers={
{_linked=1,_type = 'mframe',_upTrace=5,_id = 'Omicron',_name={['EN']="Omicron File Server",['FR']='Serveur de Omicron'},_memory=100,_link={x=192,y=31,ip="192.255.255.254"}},
{_linked=1,_type = 'database',_upTrace=10,_id = 'IAD',_name={['EN']="International Academic Database",['FR']='Base de donnees Academiques'},_memory=75,_link={x=426,y=205,ip="192.1.1.1"}},
{_linked=2,_type = 'database',_upTrace=20,_id = 'ISD',_name={['EN']="International Social Database",['FR']='Base de donnees Sociales'},_memory=55,_link={x=136,y=161,ip="192.0.0.255"}},
{_linked=3,_type = 'database',_upTrace=30,_id = 'ICD',_name={['EN']="International Criminal Database",['FR']='Base de donnees Crimininelles'},_memory=100,_link={x=386,y=46,ip="192.168.255.255"}},
{_linked=1,_type = 'bank',_upTrace=27,_id = 'IB',_name={['EN']="International Bank",['FR']='Banque Internationale'},_memory=100,_link={x=298,y=120,ip="192.168.255.255"}},
{_linked=1,_type = 'uplink',_upTrace=0,_id = 'Uplink',_name={['EN']='Uplink Gateway',['FR']='Passerelle Uplink'},_memory=0,_link={x=220,y=87,ip="10.255.255.1254"}},
{_linked=3,_type = 'mframe',_upTrace=5,_id = 'Trinity',_name={['EN']="Trinity Corp File Server",['FR']='Serveur de Trinity Corp'},_memory=100,_link={x=296,y=195,ip="192.168.100.1"}},
{_linked=2,_type = 'mframe',_upTrace=23,_id = 'DataLabs',_name={['EN']="DataLabs File Server",['FR']='Serveur de DataLabs'},_memory=75,_link={x=55,y=51,ip="192.168.0.100"}},
{_linked=4,_type = 'mframe',_upTrace=0,_id = 'Uplink Softs',_name={['EN']="Uplink Software Librabry",['FR']='FTP Uplink'},_memory=100,_link={x=146,y=235,ip="192.167.100.1"}},

}


--Complete list of available records
records = {['FR']={},['EN']={}}
records['EN']['International Academic Database']={[0]='',"PhD in Network Analysis","IEEE Accreditation","Certified Systems Engineer","PhD - Algorithms Optimization","Certified Networks Engineer"}
records['EN']['International Social Database']={[0]='',"Single","Married","Divorced","Widowed","Seperated","Employed","Un-Employed","Self-Employed","Deceased"}
records['EN']['International Criminal Database']={[0]='',"Reckless Driving","Robbery","Bank Fraud","Disturbing Public Safety","Murder","Theft","Armed Robbery","Rape","Falsifying Data","Data Theft","Illegal Attempts","Data Destruction"}

records['FR']['International Academic Database']={[0]='',"Doctorat en Analyse Réseaux","Accreditation IEEE","Ingenieur systeme","Doctorat en Optimisation d\'algorithmes","Ingenieur reseau"}
records['FR']['International Social Database']={[0]='',"Celibataire","Marie","Divorce","Veuf","Separe","Employe","Non employe","Propre entreprise","Decede"}
records['FR']['International Criminal Database']={[0]='',"Conduite dangereuse","Cambriolage","Fraude fiscale","Trouble de l\'ordre public ","Meurtre","Vol","Vol a main armee","Viol","Falsification de donnees","Vol de donnees","Actes illegaux","Destruction de donnees"}



--All gateways location
gateway={}
gateway[1]={x=67,y=102,w=7,h=7,id='Los Angeles',ip="255.0.0.1"}
gateway[2]={x=116,y=68,w=7,h=7,id='Chicago',ip="255.1.009.2"}
gateway[3]={x=141,y=81,w=7,h=7,id='New york',ip="255.1.2.356"}
gateway[4]={x=161,y=185,w=7,h=7,id='Rio',ip="255.3.056.543"}
gateway[5]={x=230,y=130,w=7,h=7,id="Ouagadougou",ip="255.345.1.1"}
gateway[6]={x=292,y=190,w=7,h=7,id="Antananarivo",ip="255.2.2.980"}
gateway[7]={x=225,y=52,w=7,h=7,id="London",ip="255.2.3.230"}
gateway[8]={x=253,y=40,w=7,h=7,id="Moscow",ip="255.456.1.1"}
gateway[9]={x=390,y=107,w=7,h=7,id="Hong Kong",ip="255.250.345.1"}
gateway[10]={x=408,y=88,w=7,h=7,id="Tokyo",ip="255.2.234.1"}
gateway[11]={x=441,y=201,w=7,h=7,id="Sydney",ip="255.1.1.1"}

--Rankings
H_rating = {
  {_rate={['EN']="Noob",['FR']="Bleu"},_success=0,_comment={['EN']="A newbie freelance hacker who signed up recently.\nTotally harmless.",['FR']='Un newbie engage en tant qu\'agent libre.\nAttend de faire ses preuves.'}},
  {_rate={['EN']="Beginner",['FR']="Debutant"},_success=2,_comment={['EN']="A rookie freelance hacker who made some successful operations.",['FR']='Un nouvel agent libre qui a mene avec succes quelques operations.'}},
  {_rate={['EN']="Intermediate",['FR']="Intermediaire"},_success=4,_comment={['EN']="We consider him as a growing threat.\nMade some successfull operations.",['FR']="Considere comme une menace grandissante.\nA mene a bien quelques operations delicates."}},
  {_rate={['EN']="Skilled",['FR']="Doue"},_success=9,_comment={['EN']="Keen on security systems hacking, potentially dangerous.",['FR']="Experimente dans le hack des systemes securises.\nMenace potencielle."}},
  {_rate={['EN']="Experienced",['FR']="Experimente"},_success=12,_comment={['EN']="This agent has lot of experience in mainframe hacking, and secured systems bypassing.\nBeware of him.",['FR']="Cet agent a beaucoup d\'experience dans le hack des serveurs et systemes securises.\nMefiez-vous-en."}},
  {_rate={['EN']="Elite",['FR']="Hackeur d\'elite"},_success=15,_comment={['EN']="A very skilled agent.\nDid efficient work for many corporations.",['FR']="Un agent tres doue.\nA mene a bien plusieurs operations delicates."}},
  {_rate={['EN']="Veteran",['FR']="Veteran"},_success=20,_comment={['EN']="A very experienced hacker,well known in world of hacking.",['FR']="Hackeur tres experimente, bien connu des services de securite informatiques."}},
  {_rate={['EN']="Expert",['FR']="Expert"},_success=25,_comment={['EN']="A highly skilled hacker, succeeded in tons of missions, probably one of the most dangerous hackers all over the Net.",['FR']='Hackeur tres doue, specialiste en missions delicates, probablement l\'un des plus dangereux hackeurs actif sur le Net.'}},
  {_rate={['EN']="Legend",['FR']="Legende"},_success=27,_comment={['EN']="This agent rocketed to fame in the world of hacking.\nLeaded many successful operations.",['FR']='Hackeur ayant atteint la notoriete mondiale.'}},
  {_rate={['EN']="Living god",['FR']="dieu vivant"},_success=30,_comment={['EN']="Currently ranked as the most threatening hacker ever.",['FR']='Black-Liste au pantheon des hackeurs de legende.'}},
  }