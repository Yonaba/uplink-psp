--[[ Uplink For PSP
	News generator definition File
	 - Create news Class
	 - Acts like a board messaging system for the player: displays flash news when special events are recordered
	]]

--[[What for ?
	- File server data loss
	- gov database security attempt
	- bank security attempt
	- Arresting people
	]]
	
--[[News Structure
   1/ headline (predefined)
   2/ details (automatically generated)
   3/ Comments (automatically generated)
   ]]
   
News = {}
News.titles = {['EN']={},['FR']={}}
News.titles['EN']= {'File Server data loss', 'Government Database records compromised','International Bank security attempt','Man arrested'}
News.titles['FR']= {'Vol de donnees sensibles', 'Integrite d\'une base de donnees gouvernementale compromise ','Attaque informatique sur un serveur de la Banque Internationale','Arret muscle d\'une personnalite'}

News.details = {['EN']={},['FR']={}}
News.comment = {['EN']={},['FR']={}}
News.details['EN'][1]='Earlier today, at timedate, targetname was attacked by cyber-criminals who stole highly important data.\n'
News.details['FR'][1]='Il y a quelques instants, a timedate, targetname a ete la cible d\'une attaque informatique.Une grande quantite de donnees sensibles ont ete volees.\n'
News.comment['EN'][1]={'The company CEO promised to reinforce their secutity parameters to prevent any other outcoming attack.',
						 'This is not the first security attempt on this server, and surely not the last one.',
						 'This attempt will certainly have enormous drawbacks on the company profits this month.'}
News.comment['FR'][1]={'Le PDG de la compagnie a promis que les parametres de securite seront renforces.',
						'Ceci n\'est pas la premiere attaque sur ce serveur, et ne sera certainement pas la derniere.',
						 'Cette attaque aura certainement d\'enormes consequences sur les benefices de ce mois de la societe.'}

News.details['EN'][2] = 'Just earlier, at timedate, targetname was attacked by a skilled hacker.\nAutorithies confirmed publicly during a press conference that records held inside the database should have been compromised.\n'										 
News.details['FR'][2] = 'Il y a quelques instants,a timedate, targetname a ete la cible d\'un hacker.\nLes autorites ont confirment publiquement durant une conference de presse que les informations enregistrees dans les bases de donnees ont pu etre modifiees.\n'										 
News.comment['EN'][2]={'Security parameters were resetted just after the hack was noticed out.',
						 'Authorities promised to investigate to find out who made such illegal attempts.',
						'The prime minister announced during an interview that \"The responsible hacker will be severely punished for his crimes\".',
						'In theory, unlawful changes to this database could result in dead people being reported as alive,or alive people being reported as dead, and the like...\n'
						}
News.comment['FR'][2]={'Les parametres de securites ont ete reinitialises juste apres que le hack soit detecte.',
						 'Les autorites ont promis qu\'aucun moyen ne sera epargne pour identifier l\'auteur de cette intrusion.',
						'Le premier ministre a officiellement annonce que \" l\'auteur de ce hack sera severement puni conformement aux textes en vigueur\".',
						'En theorie, des modifications non licites dans cette bases de donnees pourrait faire passer pour mortes des personnes en vie, et vice versa.\nChose intolerable, qui creerait surement un vent de panique dans la population.'
						}
						

News.details['EN'][3]='Earlier today, at timedate, The International Bank was the target of cyber-criminal attempts.\nAccordind to the Security Department, an account password was broken.The very scary fact is that the hacker is now capable to proceed to money transfer until the security parameters will be reset\n.'
News.details['FR'][3]='Il y quelques instants,a timedate, la Banque Internationale a ete la cible d\'une attaque cyber-criminelle.\nSelon le service Informatique de la banque, le mot de passe d\'un compte a ete decrypte depuis une passerelle distante.Le fait le plus troublant est que l\'auteur du hack est desormais en mesure de proceder a des virements de fonds jusqu\'a ce que les parametres de securite soient reinitialises.'
News.comment['EN'][3]={'The International Bank CEO apologizes publicly during a TV conference and promised to reinforce their security systems.',
						'As far as we all remember, this was not the first security attempt on the International Bank security systems.\n',
						'This event is pretty ironic, when we consider the fact that, the very last week, new security softwares were installed on International Bank public server.\nThere is actually no doubt these systems have more holes than those written the last century.\n'}
News.comment['FR'][3]={'Le PDG de la Banque Internationale a publiquement presente ses excuses durant une conference televisee et a promis de tout mettre en oeuvre pour renforcer les systemes de securite.',
						'Pour autant que nous nous en souvenons, ceci n\'est pas la premiere attaque sur le serveur public de la Banque Internationale.',
						'Cet evenement peut paraitre ironique, si nous nous rappellons que la semaine precedente, le PDG de la Banque Internationale annoncait fierement l\'acquisition de modules de securites ultra-performants pour la protection des comptes clients.\n'}						

News.details['EN'][4]='Earlier this day, at timedate, a well-known people, targetname, was arrested by federal agents for conviction.'
News.details['FR'][4]='Plus tot, a timedate, targetname une personne bien connue de l\'opinion publique, a ete arrete par des agents federaux pour conviction.'
News.comment['EN'][4]={'The man is actually jailed, and will face court in two weeks.',
						'The man family and friends have started claiming his innocence',
						'The arrest was made publicly, in a restaurant, while the man was buying burgers.\n'}
News.comment['FR'][4]={'L\'homme est actuellement en garde a vue, et comparaitra devant la Cour dans deux semaines.',
						'Sa famille et ses amis ont commence menacent de porter plainte pour diffamation.\n',
						'L\'arrestion s\'est faite en public, pendant que le suspect achetait des hamburgers dans un restaurant de la place\n.'}


function News.generate(Interface,headline,timedate,targetname,conviction)
local headlines = News.titles[Interface.locale][headline]
local details = News.details[Interface.locale][headline]
	if string.find(details,'timedate') then details = string.gsub(details,'timedate',timedate) end
	if targetname and string.find(details,'targetname') then details = string.gsub(details,'targetname',targetname) end
	if conviction and string.find(details,'conviction') then details = string.gsub(details,'conviction',conviction) end

local Ncomment = #News.comment[Interface.locale][headline]
local comment = News.comment[Interface.locale][headline][math.random(Ncomment)]

	return 'Flash News \n\n'..headlines..'\n'..details..comment
end

function News.launch(Interface,headline,timedate,targetname,conviction)
	table.insert(Interface.store,News.generate(Interface,headline,timedate,targetname,conviction))
	--Interface.nextTick = 1
	--Interface.newsTime = 1000
end