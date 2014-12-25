--[[ Uplink For PSP
  'Mission' Class definition File
   - Acts like a generator : assigns randomly a mission to the player
  ]]

--[[Types of Missions
  1/ Steal a simple file on a server : So check in Interface.dataList
        File will be deleted shortly after
  2/ Steal and decode a file on a server : So check in Interface.dataList
        File will be deleted shortly after
  3/ Modify records : social database, criminal database and academic database
  4/ Look for financial details (how much money this man have ?)
  5/ Money transfer to an account
  ]]

Mission = {}

mission = {}

Check = {}
Check[1]=function(s)
        if Interface and data and not Interface.connected and s and s.data then
          for k in ipairs(Interface.dataList) do
            if Interface.dataList[k]==s.data and data[s.data] and data[s.data].encryptionlvl == 0 then
            return true
            end
          end
        end
  return false
end

Check[2] = Check[1]
Check[3] = function(s)
  if Interface and People then
    if s.subMtype==1 then
      if People[s.targetPeople].degree==s.requiredDiploma and People[s.targetPeople].degreeClass == s.requiredClass then
      return true
      else
      return false
      end
    elseif s.subMtype==2 then
      if People[s.targetPeople].socialStatus == s.requiredSocial and People[s.targetPeople].maritalStatus == s.requiredMarital then
      return true
      else
      return false
      end
    elseif s.subMtype==3 then
      if People[s.targetPeople].conviction~='' and People[s.targetPeople].conviction==s.conviction then return true
      else return false
      end    
    end
  end
  return false
end

Check[4] = function(s)
  if Interface and People then
    if ((s.initTargetMoney-People[s.targetPeople].money)==s.sum) and ((People[s.receiverPeople].money-s.initReceiverMoney)==s.sum) then
    return true
    end
  end
  return false
end

mtitles={}
mtitles['EN'] = {
    'Hack a Mainframe and steal data',
    'Steal and decrypt sensible data',
    'Mofidy records',    
    'Perform a balance transfer'}
mtitles['FR'] = {
    'Copie de donnes depuis un serveur',
    'Vol de donnes sensibles',
    'Falsifications d\'informations',    
    'Transfert de fonds'}
    
mdesc={}
mdesc['EN'] = {'It has come to our attention that our competitor targetname has planned to release this month their latest software, something we honestly can\'t wait for.\nYour mission will be to hack into their mainframe and steal the source code packed in a single file.\nUse any means you want.In case the file is encrypted, decrypt it before.\nPayment for this job is MM credits.',
     'We are very anxious about the issues of our sales this week, and we came to the conclusion it will really be helpful to take a little advance on our rival, targetname.\nWe want you to hack into their mainframe and steal a single file.It may be encrypted,in this case, decrypt it.\nPayment for the job is MM credits.',
     'As you may be aware, we are actually in competition with targetname, to develop a software which will certainly dominate the market once released.\nUnfortunately, our lead-programmer is in custody, and we are running late.\nWe came to the conclusion the only solution is to copy our rival source code.\nA single file is required, and this will be your job to provide us this file.\nIn case the file is encrypted, decrypt it before.Payment is MM credits.',
     'I need really badly this sum of money.\nWould you please hack this account for me (accountnumber) and transfer to my personal account the money ?\nI am offering pay credits for this job.',
     'I am actually looking for a job, and I may have found a good one. Unfortunately, the following qualification is required:\n - DIPLOMA .\nThe only solution is to break into the academic database and change my records.Just give me the required diploma, with Class CLASS.\nI\'ll pay you CREDITS credits for this job.',
     'I am performing a great fraud and I would like my marital and social status to be set to:\n - Marital status:\tMARITAL\n - Social status:\tSOCIAL.\nI am offering CREDITS credits for this job.',
     'I need this person to be discredited and jailed for some time, so that any future check on his background will come up negative.\nBreak into the Criminal database and give the following conviction:\n - CONVICTION \nCREDITS credits are offered for this job.'
      }
mdesc['FR']={'Nous avons recemment appris que notre rival, targetname, compte mettre sur le marche leur dernier logiciel.Chose que nous ne pouvons pas supporter sans rien faire....\nVotre mission sera de hacker leur serveur et de voler leur code source compresse en un unique fichier.\nVous avez carte blanche.Si le fichier est crypte, decryptez le ensuite.Nous offrons pour ce travail la somme de MM credits.',
       'Nous sommes inquiets de l\'issue de la tournure que prend nos ventes de cette semaine, et nous sommes venus a la conclusion que nous devrions \'rapidement\' prendre de l\'avance sur targetname.\nNous vous demandons de hacker leur serveur et de telecharger un fichier.Il sera peut etre crypte, dans ce cas, decryptez - le. Votre retribution sera de MM credits.',
       'Nous sommes actuellement en competition avec targetname sur la mise au projet d\'un logiciel qui fera certainement succes une fois mis sur le marche.\nLe probleme est que notre programmeur-en-chef est actuellement inculpe, et nous prenons du retard.\nNous voulons copier le code source de nos rivaux, qui semble excellent, a la facon dont ils nous narguent.\nVous devrez recuperer ce fichier pour nous, et le decrypter au cas ou il serait encrypte.\nNous offrons comme retribution MM credits.',
       'J\'ai vraiment besoin de cette somme d\'argent en plus sur mon compte.Votre travail sera de me transferer cette somme que vous preleverez sur le compte (accountnumber).\nJ\'offre pay credits pour ce travail.',
       'Je suis a la recherche d\'un nouveau job, et j\'en ai deja trouve un.\nMalheureusement, il me faut la qualification suivante pour postuler:\n\tDIPLOMA, de classe CLASS\nLa solution serait d\'infiltrer la base de donnes academiques et de modifier mon dossier.\nJ\'offre CREDITS credits pour ce job.',
       'Afin de pouvoir beneficier de certains avantages, je voudrais que mes donnes sociales soient reinitialisees comme suit:\n - Statut conjugal:\tMARITAL\n - Statut social:\tSOCIAL.\nJ\'offre CREDITS credits pour ce travail.',
       'Cette personne doit etre publiquement discreditee et mise a l\'ombre pour un certain temps.\ninfiltrez la base de donnes des informations criminelles et assignez lui la condamnation suivante:\n - CONVICTION\nCREDITS credits sont offerts pour ce travail.'
       }    
  
function Mission:generateDesc()
  if Interface then
    if self.mtype==1 or self.mtype==2 then
    local targetname = H_servers[self.target]._id
    local employername = H_servers[self.employer]._id
    local title = mtitles[Interface.locale][self.mtype]
    local filename
    if self.mtype ==1 or self.mtype==2 then
    filename = data[self.data].name
    end
    self.desc = locale.memployer..employername..'\n'..locale.mtarget..targetname..'\n'..locale.mtitle..title..'\n'..locale.mfilename..filename..'\n'
    local comment = mdesc[Interface.locale][math.random(1,3)]
    comment = string.gsub(comment,'targetname',targetname)
    comment = string.gsub(comment,'MM credits',self.cost)
    self.desc = self.desc..comment
    elseif self.mtype==3 then
      if self.subMtype==1 then
      local employername = People[self.targetPeople].name..' '..People[self.targetPeople].name2
      self.employername = employername or ''
      self.desc = locale.memployer..employername..'\n'..locale.mtitle..mtitles[Interface.locale][self.mtype]..'\n\n'
      local comment = mdesc[Interface.locale][5]      
      comment = string.gsub(comment,'DIPLOMA',self.Diploma)
      comment = string.gsub(comment,'CLASS',self.requiredClass)
      comment = string.gsub(comment,'CREDITS',self.cost)
      self.desc = self.desc..comment

      elseif self.subMtype==2 then
      local employername = People[self.targetPeople].name..' '..People[self.targetPeople].name2
      self.employername = employername or ''      
      self.desc = locale.memployer..employername..'\n'..locale.mtitle..mtitles[Interface.locale][self.mtype]..'\n\n'
      local comment = mdesc[Interface.locale][6]      
      comment = string.gsub(comment,'MARITAL',self.ftMarital)
      --oldprint('--comment subbing MARITAL---',comment)
      comment = string.gsub(comment,'SOCIAL',self.ftSocial)
      --oldprint('--comment subbing SOCIAL---',comment)
      comment = string.gsub(comment,'CREDITS',self.cost)  
      --oldprint('--comment subbing CREDITS---',comment)
      self.desc = self.desc..comment
      elseif self.subMtype==3 then
      self.employername = employername or ''      
      local employername = (Interface.locale=='EN') and 'Anonymous' or 'Anonyme'
      self.desc = locale.memployer..employername..'\n'..locale.mtitle..mtitles[Interface.locale][self.mtype]..'\n'..locale.peopleTargetted
      self.desc = self.desc..People[self.targetPeople].name..' '..People[self.targetPeople].name2..'\n\n'
      local comment = mdesc[Interface.locale][7]
      comment = string.gsub(comment,'CONVICTION',self.convictionText)
      comment = string.gsub(comment,'CREDITS',self.cost)
      self.desc = self.desc..comment
      end    
    elseif self.mtype==4 then
      if People then
      local Asker = People[self.receiverPeople].name..' '..People[self.receiverPeople].name2
      local title = mtitles[Interface.locale][self.mtype]
      self.desc = locale.memployer..Asker..'\n'..locale.mtitle..title..'\n'..locale.employerAccount..People[self.receiverPeople].acc..'\n'..locale.targetAccount..People[self.targetPeople].acc..'\n'..locale.accPass..People[self.targetPeople].pass..'\n'..locale.sumToTransfer..self.sum
      local comment  = mdesc[Interface.locale][self.mtype]
      comment = string.gsub(comment,'(accountnumber)',People[self.targetPeople].acc)
      comment = string.gsub(comment,'pay',self.cost)
      self.desc =  self.desc..'\n\n'..comment  
      end
    end
  end
end
  
function Mission:askAcceptance()
  self:generateDesc()
  System.message(self.desc,1)
    if System.buttonPressed(1)=='yes' then
    self.accepted = true
      if Ctime then Ctime.nextM=false end
    else
    self.accepted = false
      if Ctime then Ctime.nextM=true end
      if mission then 
        for k in pairs(mission) do table.remove(mission,k) end
      end       
    end
end

function Mission:draw()
System.message(self.desc,0)
end


function Mission:check()
  return Check[self.mtype](self)
end

function Mission:send()
local _done = self:check()
  if not _done then
  System.message(locale.AbortNow,1) 
    if System.buttonPressed(1)=='yes' then  
    local Failed = ''
      if Interface and Interface.locale=='EN' then
      Failed = 'You have completely failed the current mission.\nSomeone more qualified will be required the next time.'
      elseif Interface and Interface.locale =='FR' then
      Failed = 'Vous avez echoue sur cette mission.\nIl faudra faire recours a quelqu\'un de mieux qualifie la prochaine fois.'
      end      
    System.message(Failed,0)
      if mission then 
        for k in pairs(mission) do table.remove(mission,k) end
      end   
      if Ctime then Ctime.nextM=true end
      if Interface and Interface.currentProfile.numHackSuccess > 0 then Interface.currentProfile.numHackSuccess = Interface.currentProfile.numHackSuccess - 1 end
    end  
  else
  local backUp = ''
  local employername = ''
    if self.mtype==1 or self.mtype==2 then employername = H_servers[self.employer]._id
    elseif self.mtype == 3 then
    employername = self.employername
    elseif People and self.mtype==4 then employername = People[self.receiverPeople].name..' '..People[self.receiverPeople].name2
    end
    
    if Interface and Interface.locale=='EN' then
    backUp = 'From: '..employername..'\nObject: Thanks\n\nCongratulations for the good job you did.\nAccording to our terms, the payment was transferred on your account.\nYours, truly.'
    elseif Interface and Interface.locale =='FR' then
    backUp = 'Message de: '..employername..'\Sujet: Remerciements\n\nFelicitations pour l\'excellent travail que vous avez fait.\nComme convenu, votre paye a deja ete transferee sur votre compte.\nSincerement votre.'
    end
  System.message(backUp,0)
    if  Interface then 
      if Interface.currentProfile.money then Interface.currentProfile.money =  Interface.currentProfile.money + self.cost end
      if Interface.currentProfile.numHackSuccess then Interface.currentProfile.numHackSuccess = Interface.currentProfile.numHackSuccess + 1 end
    end
    if mission then 
      for k in pairs(mission) do table.remove(mission,k) end
    end   
    if Ctime then Ctime.nextM=true end    
  end
end


function Mission:new()
self.__index = self
local mtype = math.random(1,4)

--oldprint('generating mission')
local This = {}
  if mtype==1 or mtype==2 then
  This.mtype = mtype
  --oldprint('mtype is',mtype)
  local targetList = {}
  local dataList = {}
    if H_servers and data and mainframe then 
      for k in ipairs(H_servers) do
        if H_servers[k]._type =='mframe' and H_servers[k]._id~='Uplink Softs' then table.insert(targetList,k) end
      end
      local n = math.random(1,#targetList)
      This.target = targetList[n]
      table.remove(targetList,n)
      This.employer = targetList[math.random(1,#targetList)]
      --oldprint('target is',H_servers[This.target]._id)
      --oldprint('employer is',H_servers[This.employer]._id)
        for k in ipairs(data) do
          if data[k].owner == H_servers[This.target]._id then 
            if mtype==1 then 
              if data[k].encryptionlvl ==0 then table.insert(dataList,k) end
            elseif mtype==2 then
              if data[k].encryptionlvl > 0 then table.insert(dataList,k) end
            end
          end        
        end
      --oldprint('dataList sz',#dataList,unpack(dataList))
      This.data = dataList[math.random(1,#dataList)]
      --oldprint('data',This.data)
      This.cost = ((mtype*1000)+(data[This.data].size*100)+(data[This.data].encryptionlvl*100))+(mainframe[H_servers[This.target]._linked].sec*1000)/2
      This.accepted = true
      This.desc = ''
    end
  elseif mtype==4 then
    if People then
    This.mtype = mtype
    --oldprint('mtype',mtype)
    This.sum = thousandFloor(math.random(20000,100000))
    --oldprint('sum',This.sum)
    This.targetPeople = seekFor(People,This.sum)
    This.initTargetMoney = People[This.targetPeople].money
      if not This.targetPeople then 
        if mission then mission = {} end
        if Ctime then Ctime.nextM = true end
        return
      end
    --oldprint('target',This.targetPeople)    
    This.receiverPeople = math.random(1,#People)
    This.initReceiverMoney = People[This.receiverPeople].money
    --oldprint('recv',This.receiverPeople)
    This.cost = ((mtype*2*1000)+ tenFloor(math.ceil(This.sum/100)))
    --oldprint('cost',This.cost)
    end
  elseif mtype==3 then
    if People and Interface and records then
    This.mtype = mtype
    --//SubmType refers to : 1/Academic 2/Social 3/criminal
    --This.subMtype = math.random(1,3)
    This.subMtype = math.random(1,3)
      if This.subMtype==1 then
      This.requiredDiploma = math.random(1,#records[Interface.locale]['International Academic Database'])
      This.Diploma = records[Interface.locale]['International Academic Database'][This.requiredDiploma]
      This.requiredClass = math.random(1,4)
      local list = {}
        for k in ipairs(People) do
          if People[k].degree and People[k].degree ~= This.requiredDiploma then table.insert(list,k) end
        end
        if #list > 0 then
        This.targetPeople = math.random(1,#list)
        else
          if mission then mission = {} end
          if Ctime then Ctime.nextM = true end
          return    
        end
      This.cost = ((mtype*1000)+(This.requiredClass*1000))
      elseif This.subMtype==2 then
      This.targetPeople = math.random(1,#People)
      This.requiredMarital = math.random(1,5)
      This.requiredSocial = math.random(6,#records[Interface.locale]['International Social Database'])
      This.ftMarital = records[Interface.locale]['International Social Database'][This.requiredMarital]
      This.ftSocial = records[Interface.locale]['International Social Database'][This.requiredSocial]      
      This.cost = ((This.mtype*1000)+(This.subMtype*2*1000))
      elseif This.subMtype==3 then
      This.targetPeople = math.random(1,#People)
      This.conviction = math.random(1,#records[Interface.locale]['International Criminal Database'])
      This.convictionText = records[Interface.locale]['International Criminal Database'][This.conviction]
      This.cost = ((This.mtype*1000)+(This.subMtype*2*1000))
      end
    end
  end  
  return setmetatable(This,self)
end

function Mission.Draw(cursor,key,oldkey)  
  if mission and #mission>0 then
  --oldprint(#mission)
    if Interface then
      if Interface.Buttons.missionDesc:hasClicked(cursor,key,oldkey) then mission[1]:draw()end
      if Interface.Buttons.sendNote:hasClicked(cursor,key,oldkey) then mission[1]:send() end
    Interface.Buttons.missionDesc:draw(cursor,key,oldkey)  
    Interface.Buttons.sendNote:draw(cursor,key,oldkey)  
    end
  end
end
