
local ConfigScene = class("ConfigScene", function()
    return display.newScene("ConfigScene")
end)

function ConfigScene:ctor()
	self.uiLayer = display.newLayer()
	self:addChild(self.uiLayer)
	local uiBg = display.newScale9Sprite("BlueBlock.png")
	uiBg:setContentSize(display.width,display.height)
	uiBg:setAnchorPoint(cc.p(0,0))
	self.uiLayer:addChild(uiBg,-1)
end

function ConfigScene:onEnter()
	self.configLabel = display.newTTFLabel({text = "Config", size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(self.uiLayer)
	self.initDataLabel = display.newTTFLabel({text = "InitData", size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(self.uiLayer)

	self.saveButton = cc.ui.UIPushButton.new("Button01.png")
		:setButtonLabel("normal", cc.ui.UILabel.new({text="Save",color=display.COLOR_WHITE,size=16,align = cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}))
		:setButtonSize(80, 40)
		:onButtonClicked(function ( event )
			-- get all data change
			ConfigMgr.saveConfigToFile()
			InitDataMgr.saveInitDataToFile()
		end)
		:addTo(self.uiLayer)
	self.returnButton = cc.ui.UIPushButton.new("Button01.png")
		:setButtonLabel("normal", cc.ui.UILabel.new({text="Return",color=display.COLOR_WHITE,size=16,align = cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}))
		:setButtonSize(80, 40)
		:onButtonClicked(function ( event )
			app:enterScene("FirstScene")
		end)
		:addTo(self.uiLayer)

	self.configList = cc.ui.UIListView.new({
			direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
	        -- bg="BlueBlock.png",
	        -- bgScale9=true,
	        viewRect=cc.rect(20, 80, display.cx - 40, display.top - 160)
		}):addTo(self.uiLayer)
	self.configList:setAnchorPoint(cc.p(0,0))

	self.initDataList = cc.ui.UIListView.new({
			direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
	        -- bg="BlueBlock.png",
	        -- bgScale9=true,
	        viewRect=cc.rect(display.cx + 20, 80, display.cx - 40, display.top - 160)
		}):addTo(self.uiLayer)
	self.initDataList:setAnchorPoint(cc.p(0,0))

	self:postInit()
	self:fillContent()
end

function ConfigScene:postInit()
	self.configLabel:size(display.cx - 40,40)
	self.configLabel:align(display.CENTER, display.cx / 2, display.top - 30)

	self.initDataLabel:size(display.cx - 40,40)
	self.initDataLabel:align(display.CENTER, display.cx + display.cx / 2, display.top - 30)

	self.saveButton:setButtonLabelOffset(-5,-20)
	self.saveButton:align(display.BOTTOM_LEFT, display.cx - 100, 20)

	self.returnButton:setButtonLabelOffset(-5,-20)
	self.returnButton:align(display.BOTTOM_LEFT, display.cx + 20, 20)

end

function ConfigScene:fillContent()
	local initData = InitDataMgr.getFullInitDataCopy()

	-- init pop content
	local popItem = self.initDataList:newItem()
    local popContent = display.newNode()
    popContent:setContentSize(display.cx - 40, 240)
    popItem:setItemSize(display.cx - 40, 240)
    popItem:addContent(popContent)
    self.initDataList:addItem(popItem)
    self.popEditBoxes = {}
    local popIndex = 1
    for k,v in pairs(initData.pop) do
    	local l = display.newTTFLabel({text = k .. ":", size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(popContent)
    	local h = (popIndex - 1) * 40
    	l:align(display.BOTTOM_LEFT, 10, h)
    	local editbox = cc.ui.UIInput.new({
	        image = display.newScale9Sprite("EditBoxBg.png"),
	        size = cc.size(200, 40),
	    }):addTo(popContent)
	    editbox:align(display.BOTTOM_LEFT, 220, h)
	    editbox:setText(v)
	    self.popEditBoxes[k] = editbox
	    popIndex = popIndex + 1
    end

    local popSaveButtonItem = self.initDataList:newItem()
    popSaveButtonItem:setItemSize(80, 40)
    local popSaveButtonContent = cc.ui.UIPushButton.new("Button01.png")
		:setButtonLabel("normal", cc.ui.UILabel.new({text="Save",color=display.COLOR_WHITE,size=16,align = cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}))
		:setButtonSize(80, 40)
		:onButtonClicked(function ( event )
			self:setInitDataValue("pop")
		end)
	popSaveButtonItem:addContent(popSaveButtonContent)
    self.initDataList:addItem(popSaveButtonItem)

    -- init product content
	local productItem = self.initDataList:newItem()
    local productContent = display.newNode()
    productContent:setContentSize(display.cx - 40, 240)
    productItem:setItemSize(productContent:getContentSize().width, productContent:getContentSize().height)
    productItem:addContent(productContent)
    self.initDataList:addItem(productItem)
    self.productEditBoxes = {}
    local productIndex = 1
    for k,v in pairs(initData.product) do
    	local l = display.newTTFLabel({text = k .. ":", size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(productContent)
    	local h = (productIndex - 1) * 40
    	l:align(display.BOTTOM_LEFT, 10, h)
    	local editbox = cc.ui.UIInput.new({
	        image = display.newScale9Sprite("EditBoxBg.png"),
	        size = cc.size(200, 40),
	    }):addTo(productContent)
	    editbox:align(display.BOTTOM_LEFT, 220, h)
	    editbox:setText(v)
	    self.productEditBoxes[k] = editbox
	    productIndex = productIndex + 1
    end

    local productSaveButtonItem = self.initDataList:newItem()
    productSaveButtonItem:setItemSize(80, 40)
    local productSaveButtonContent = cc.ui.UIPushButton.new("Button01.png")
		:setButtonLabel("normal", cc.ui.UILabel.new({text="Save",color=display.COLOR_WHITE,size=16,align = cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}))
		:setButtonSize(80, 40)
		:onButtonClicked(function ( event )
			self:setInitDataValue("product")
		end)
	productSaveButtonItem:addContent(productSaveButtonContent)
    self.initDataList:addItem(productSaveButtonItem)

    -- init factory content
	local factoryItem = self.initDataList:newItem()
    local factoryContent = display.newNode()
    factoryContent:setContentSize(display.cx - 40, 1800)
    factoryItem:setItemSize(factoryContent:getContentSize().width, factoryContent:getContentSize().height)
    factoryItem:addContent(factoryContent)
    self.initDataList:addItem(factoryItem)
    self.factoryEditBoxes = {}
    local factoryIndex = 1
    for k,v in pairs(initData.factory) do
    	local f = {}
    	
    	local h
    	local l
    	local editbox
    	f.pop = {}
    	for i=3,1,-1 do
    		l = display.newTTFLabel({text = "pop" .. i .. ":", size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(factoryContent)
	    	h = (factoryIndex - 1) * 40
	    	l:align(display.BOTTOM_LEFT, 10, h)
	    	editbox = cc.ui.UIInput.new({
		        image = display.newScale9Sprite("EditBoxBg.png"),
		        size = cc.size(200, 40),
		    }):addTo(factoryContent)
		    editbox:align(display.BOTTOM_LEFT, 220, h)
		    if not v.pop[i] then
		    	editbox:setText("0")
		    else
		    	editbox:setText(v.pop[i])
		    end
		    f.pop[i] = editbox
		    factoryIndex = factoryIndex + 1
    	end

    	l = display.newTTFLabel({text = "level:", size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(factoryContent)
    	h = (factoryIndex - 1) * 40
    	l:align(display.BOTTOM_LEFT, 10, h)
    	editbox = cc.ui.UIInput.new({
	        image = display.newScale9Sprite("EditBoxBg.png"),
	        size = cc.size(200, 40),
	    }):addTo(factoryContent)
	    editbox:align(display.BOTTOM_LEFT, 220, h)
	    editbox:setText(v.level)
	    f.level = editbox
	    self.factoryEditBoxes[k] = f
	    factoryIndex = factoryIndex + 1

	    local l = display.newTTFLabel({text = k, size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(factoryContent)
	    h = (factoryIndex - 1) * 40
	    factoryIndex = factoryIndex + 1
    	l:align(display.CENTER, (display.cx - 40) /2, h + 20)
    end

    local factorySaveButtonItem = self.initDataList:newItem()
    factorySaveButtonItem:setItemSize(80, 40)
    local factorySaveButtonContent = cc.ui.UIPushButton.new("Button01.png")
		:setButtonLabel("normal", cc.ui.UILabel.new({text="Save",color=display.COLOR_WHITE,size=16,align = cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}))
		:setButtonSize(80, 40)
		:onButtonClicked(function ( event )
			self:setInitDataValue("factory")
		end)
	factorySaveButtonItem:addContent(factorySaveButtonContent)
    self.initDataList:addItem(factorySaveButtonItem)


    self.initDataList:reload()

    local conf = ConfigMgr.getFullConfigCopy()

    self.popConfigs = {}
    self.factoryConfigs = {}
    for k,v in pairs(conf) do
    	-- pop
    	if v.class then
    		self.popConfigs[k] = v
    	else -- factory
    		self.factoryConfigs[k] = v
    	end
    end

    local popConfigItem = self.configList:newItem()
    local popConfigContent = display.newNode()
    popConfigItem:addContent(popConfigContent)
    popConfigItem:setItemSize(440,4360)
    self.configList:addItem(popConfigItem)

    --pop config
	local popConfigIndex = 1
	self.popConfigEditBoxes = {}
    for k,v in pairs(self.popConfigs) do
    	local p = {}
    	local h
    	local l
    	local editbox
    	for kk,vv in pairs(v) do
    		l = display.newTTFLabel({text = kk, size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(popConfigContent)
	    	h = (popConfigIndex - 1) * 40
	    	l:align(display.BOTTOM_LEFT, 10, h)
	    	editbox = cc.ui.UIInput.new({
		        image = display.newScale9Sprite("EditBoxBg.png"),
		        size = cc.size(200, 40),
		    }):addTo(popConfigContent)
		    editbox:align(display.BOTTOM_LEFT, 220, h)
		    editbox:setText(vv)
		    p[kk] = editbox
		    self.popConfigEditBoxes[k] = p
		    popConfigIndex = popConfigIndex + 1
    	end

	    l = display.newTTFLabel({text = k, size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(popConfigContent)
	    h = (popConfigIndex - 1) * 40
	    popConfigIndex = popConfigIndex + 1
    	l:align(display.CENTER, (display.cx - 40) /2, h + 20)
    end
    popConfigContent:setContentSize(display.cx - 40, popConfigIndex * 40) 

    local popConfigSaveButtonItem = self.initDataList:newItem()
    popConfigSaveButtonItem:setItemSize(80, 40)
    local popConfigSaveButtonContent = cc.ui.UIPushButton.new("Button01.png")
		:setButtonLabel("normal", cc.ui.UILabel.new({text="Save",color=display.COLOR_WHITE,size=16,align = cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}))
		:setButtonSize(80, 40)
		:onButtonClicked(function ( event )
			self:setConfigValue("pop")
		end)
	popConfigSaveButtonItem:addContent(popConfigSaveButtonContent)
    self.configList:addItem(popConfigSaveButtonItem)

    --factory config
    local factoryConfigItem = self.configList:newItem()
    local factoryConfigContent = display.newNode()
    factoryConfigItem:addContent(factoryConfigContent)
    factoryConfigItem:setItemSize(440,29600)
    self.configList:addItem(factoryConfigItem)

    local factoryConfigIndex = 1
	self.factoryConfigEditBoxes = {}
    for k,v in pairs(self.factoryConfigs) do
    	self.factoryConfigEditBoxes[k] = {}
    	local f = {}
    	local h
    	local l
    	local editbox
    	for i,vv in ipairs(v) do
    		--pop
    		local pop = {}
    		for ii,vvv in ipairs(vv.pop) do
    			local popV = {}
    			l = display.newTTFLabel({text = "pop" .. ii .. ".name:", size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(factoryConfigContent)
		    	h = (factoryConfigIndex - 1) * 40
		    	l:align(display.BOTTOM_LEFT, 10, h)
		    	editbox = cc.ui.UIInput.new({
			        image = display.newScale9Sprite("EditBoxBg.png"),
			        size = cc.size(200, 40),
			    }):addTo(factoryConfigContent)
			    editbox:align(display.BOTTOM_LEFT, 220, h)
			    editbox:setText(vvv.name)
			    popV.name = editbox
			    factoryConfigIndex = factoryConfigIndex + 1

			    l = display.newTTFLabel({text = "pop" .. ii .. ".value:", size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(factoryConfigContent)
		    	h = (factoryConfigIndex - 1) * 40
		    	l:align(display.BOTTOM_LEFT, 10, h)
		    	editbox = cc.ui.UIInput.new({
			        image = display.newScale9Sprite("EditBoxBg.png"),
			        size = cc.size(200, 40),
			    }):addTo(factoryConfigContent)
			    editbox:align(display.BOTTOM_LEFT, 220, h)
			    editbox:setText(vvv.value)
			    popV.value = editbox
			    factoryConfigIndex = factoryConfigIndex + 1

			    pop[ii] = popV
			    f.pop = pop
    		end
    		self.factoryConfigEditBoxes[k][i] = f
			
    		--input
    		local input = {}
    		for ii,vvv in ipairs(vv.input) do
    			local inputV = {}
    			l = display.newTTFLabel({text = "input" .. ii .. ".name:", size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(factoryConfigContent)
		    	h = (factoryConfigIndex - 1) * 40
		    	l:align(display.BOTTOM_LEFT, 10, h)
		    	editbox = cc.ui.UIInput.new({
			        image = display.newScale9Sprite("EditBoxBg.png"),
			        size = cc.size(200, 40),
			    }):addTo(factoryConfigContent)
			    editbox:align(display.BOTTOM_LEFT, 220, h)
			    editbox:setText(vvv.name)
			    inputV.name = editbox
			    factoryConfigIndex = factoryConfigIndex + 1

			    l = display.newTTFLabel({text = "input" .. ii .. ".value:", size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(factoryConfigContent)
		    	h = (factoryConfigIndex - 1) * 40
		    	l:align(display.BOTTOM_LEFT, 10, h)
		    	editbox = cc.ui.UIInput.new({
			        image = display.newScale9Sprite("EditBoxBg.png"),
			        size = cc.size(200, 40),
			    }):addTo(factoryConfigContent)
			    editbox:align(display.BOTTOM_LEFT, 220, h)
			    editbox:setText(vvv.value)
			    inputV.value = editbox
			    factoryConfigIndex = factoryConfigIndex + 1

			    input[ii] = inputV
			    f.input = input
    		end

    		--output
    		local output = {}
    		for ii,vvv in ipairs(vv.output) do
    			local outputV = {}
    			l = display.newTTFLabel({text = "output" .. ii .. ".name:", size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(factoryConfigContent)
		    	h = (factoryConfigIndex - 1) * 40
		    	l:align(display.BOTTOM_LEFT, 10, h)
		    	editbox = cc.ui.UIInput.new({
			        image = display.newScale9Sprite("EditBoxBg.png"),
			        size = cc.size(200, 40),
			    }):addTo(factoryConfigContent)
			    editbox:align(display.BOTTOM_LEFT, 220, h)
			    editbox:setText(vvv.name)
			    outputV.name = editbox
			    factoryConfigIndex = factoryConfigIndex + 1

			    l = display.newTTFLabel({text = "output" .. ii .. ".value:", size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(factoryConfigContent)
		    	h = (factoryConfigIndex - 1) * 40
		    	l:align(display.BOTTOM_LEFT, 10, h)
		    	editbox = cc.ui.UIInput.new({
			        image = display.newScale9Sprite("EditBoxBg.png"),
			        size = cc.size(200, 40),
			    }):addTo(factoryConfigContent)
			    editbox:align(display.BOTTOM_LEFT, 220, h)
			    editbox:setText(vvv.value)
			    outputV.value = editbox
			    factoryConfigIndex = factoryConfigIndex + 1

			    output[ii] = outputV
			    f.output = output
    		end
    		l = display.newTTFLabel({text = "level:" .. i, size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(factoryConfigContent)
	    	h = (factoryConfigIndex - 1) * 40
	    	l:align(display.BOTTOM_LEFT, 10, h)
		    factoryConfigIndex = factoryConfigIndex + 1
    	end

	    l = display.newTTFLabel({text = k, size = 20, color = display.COLOR_WHITE,align=cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}):addTo(factoryConfigContent)
	    h = (factoryConfigIndex - 1) * 40
	    factoryConfigIndex = factoryConfigIndex + 1
    	l:align(display.CENTER, (display.cx - 40) /2, h + 20)
    end
    factoryConfigContent:setContentSize(display.cx - 40, factoryConfigIndex * 40)

    local factoryConfigSaveButtonItem = self.initDataList:newItem()
    factoryConfigSaveButtonItem:setItemSize(80, 40)
    local factoryConfigSaveButtonContent = cc.ui.UIPushButton.new("Button01.png")
		:setButtonLabel("normal", cc.ui.UILabel.new({text="Save",color=display.COLOR_WHITE,size=16,align = cc.ui.TEXT_ALIGN_CENTER,valign=cc.ui.TEXT_VALIGN_CENTER}))
		:setButtonSize(80, 40)
		:onButtonClicked(function ( event )
			self:setConfigValue("factory")
		end)
	factoryConfigSaveButtonItem:addContent(factoryConfigSaveButtonContent)
    self.configList:addItem(factoryConfigSaveButtonItem)

    self.configList:reload()
end

function ConfigScene:onExit()

end

function ConfigScene:setInitDataValue(blockName)
	if blockName == "pop" then
		for k,v in pairs(self.popEditBoxes) do
			local text = string.trim(v:getText())

			InitDataMgr.setPopInitData(k,tonumber(text))
		end
	end

	if blockName == "product" then
		for k,v in pairs(self.productEditBoxes) do
			local text = string.trim(v:getText())
			InitDataMgr.setProductInitData(k,tonumber(text))
		end
	end

	if blockName == "factory" then
		for k,v in pairs(self.factoryEditBoxes) do
			local value = {}
			value.pop = {}
			local text
			text = string.trim(v.level:getText())
			value.level = tonumber(text)
			for i=1,3 do
				text = string.trim(v.pop[i]:getText())
				value.pop[i] = tonumber(text)
			end
			InitDataMgr.setFactoryInitData(k,value)
		end
	end
end

function ConfigScene:setConfigValue(blockName)
	if blockName == "pop" then
		for k,v in pairs(self.popConfigEditBoxes) do
			local value = {}
			local text
			local toN
			for kk,vv in pairs(v) do
				text = string.trim(vv:getText())
				toN = tonumber(text)
				if toN then
					value[kk] = toN
				else
					value[kk] = text
				end
			end
			ConfigMgr.setConfig(k,value)
		end
	end

	if blockName == "factory" then
		for k,v in pairs(self.factoryConfigEditBoxes) do
			local value = {}
			for i,vv in ipairs(v) do
				value[i]  = {}
				value[i].pop = {}
				value[i].output = {}
				value[i].input = {}
				local text
				local toN
				for ii,vvv in ipairs(vv.pop) do
					value[i].pop[ii] = {}
					for kk,vvvv in pairs(vvv) do
						text = string.trim(vvvv:getText())
						toN = tonumber(text)
						if toN then
							value[i].pop[ii][kk] = toN
						else
							value[i].pop[ii][kk] = text
						end
					end
				end

				for ii,vvv in ipairs(vv.input) do
					value[i].input[ii] = {}
					for kk,vvvv in pairs(vvv) do
						text = string.trim(vvvv:getText())
						toN = tonumber(text)
						if toN then
							value[i].input[ii][kk] = toN
						else
							value[i].input[ii][kk] = text
						end
					end
				end

				for ii,vvv in ipairs(vv.output) do
					value[i].output[ii] = {}
					for kk,vvvv in pairs(vvv) do
						text = string.trim(vvvv:getText())
						toN = tonumber(text)
						if toN then
							value[i].output[ii][kk] = toN
						else
							value[i].output[ii][kk] = text
						end
					end
				end
			end
			
			ConfigMgr.setConfig(k,value)
		end
	end
end

return ConfigScene
