import("..includes.UserDataFunction")
import("..config.Config")
import("..config.InitData")
local TopShowNode = require("app.ui.TopShowNode")
local FactoryShowNode = require("app.ui.FactoryShowNode")

local lastCalTime = os.time()

local FirstScene = class("FirstScene", function()
    return display.newScene("FirstScene")
end)
-- 主要计算逻辑 暂定每3秒执行一次
function FirstScene:tick(dt)
    local nowTime = os.time()
    if nowTime - lastCalTime > 3 then
        lastCalTime = lastCalTime + 3;
        -- 先计算工厂的产出
        local output = {}
        local buff = 0
        local his = {}
        his.factory = {}
        for k,_ in pairs(data.factory) do
            --calOutput 计算工厂的产出
            his.factory[k] = {}
            his.factory[k].output = {}
            local o = calOutput(k,data,config) 
            for _,vv in ipairs(o) do
                if vv.name == "pdtRate0" then
                    buff = buff + vv.value
                else
                    if not output[vv.name] then
                        output[vv.name] = 0
                    end
                    output[vv.name] = output[vv.name] + vv.value
                end
                local outp = {}
                outp.name = vv.name
                outp.value = vv.value
                table.insert(his.factory[k].output, outp)
            end
        end

        his.product = {}
        local bufferedOutPut = {}
        --配上银行的产出buff
        for k,v in pairs(output) do
            local va = getIntPart(v * (1 + buff))
            bufferedOutPut[k] = va
            his.product[k] = va
        end

        --将工厂的产出添加到持有资源data.product
        addOutput(bufferedOutPut,data)

        -- 再计算食物分配
        local popGens = calRequiredSupply(data,config,his)

        his.pop = {}
        for k,v in pairs(popGens) do
            for kk,vv in pairs(v) do
                if not his.pop[kk] then
                    his.pop[kk] = {}
                end
                his.pop[kk][k] = vv
            end
        end

        -- 再根据食物的分配计算人口增长
        local popGrowth = calPopGrowth(popGens,data,config,his)

        --对工作人口进行重新分配
        reDistributeWorker(data,config,his)

        table.insert(data.history, 1 , his)

        for i=1,#self.factoryListView.items_ do
            local content = self.factoryListView.items_[i]:getContent()
            content:refresh(content:getTitle(),data.factory[content:getTitle()])
        end

        local tags = {}
        for k,v in pairs(data.product) do
            table.insert(tags, k)
        end
        table.insert(tags, 1, "pop")

        for i,v in ipairs(tags) do
            local nod = self.uiLayer:getChildByTag(10000 + i)
            if v == "pop" then
                nod:refresh({amount=his.pop.pop.total,amountChange=his.pop.pop.add})
            else
                nod:refresh({amount=data.product[v],amountChange=his.product[v]})
            end
            
        end


        -- TODO 最后计算人口之间的转化
        
    end
end

function FirstScene:ctor()
	self.uiLayer = display.newLayer()
	self:addChild(self.uiLayer)
	local uiBg = display.newScale9Sprite("BlueBlock.png")
	uiBg:setContentSize(display.width,display.height)
	uiBg:setAnchorPoint(cc.p(0,0))
	self.uiLayer:addChild(uiBg,-1)
end

function FirstScene:onEnter()
    
    local tags = {}
    for k,v in pairs(data.product) do
        table.insert(tags, k)
    end
    table.insert(tags, 1, "pop")

    for i,v in ipairs(tags) do
        local nod = TopShowNode.new({title=v}):addTo(self.uiLayer,1,10000 + i)
        nod:pos(TopShowNode.COLUMN_PADDING * i + (i - 1) * TopShowNode.DEFAULT_WIDTH, display.top - 10 - TopShowNode.DEFAULT_HEIGHT)
        if v == "pop" then
            local total = 0
            for k,vv in pairs(data.pop) do
                total = total + vv
            end
            nod:refresh({amount=total,amountChange=0})
        else
            nod:refresh({amount=data.product[v],amountChange=0})
        end
    end

    -- self.popListView = cc.ui.UIListView.new({
    --     direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
    --     -- bg="BlueBlock.png",
    --     -- bgScale9=true,
    --     viewRect=cc.rect(10, 10, display.cx - 20, display.top - 50 - TopShowNode.DEFAULT_HEIGHT)
    --     })
    -- self.popListView:setAnchorPoint(cc.p(0,0))
    -- self.popListView:addTo(self.uiLayer)

    -- for i=1,6 do
    --     local item = self.popListView:newItem()
    --     item:setItemSize(FactoryShowNode.DEFAULT_WIDTH, FactoryShowNode.DEFAULT_HEIGHT)
    --     local content = FactoryShowNode.new({title="pop"})
    --     content:setContentSize(FactoryShowNode.DEFAULT_WIDTH, FactoryShowNode.DEFAULT_HEIGHT)
    --     content:setAnchorPoint(cc.p(0,0))
        
    --     content:refresh({amount=1000,amountChange=-1000})
    --     item:addContent(content)
    --     self.popListView:addItem(item)
    -- end
    -- self.popListView:reload()


    self.factoryListView = cc.ui.UIListView.new({
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
        -- bg="BlueBlock.png",
        -- bgScale9=true,
        viewRect=cc.rect(display.cx + 10, 10, display.cx - 20, display.top - 50 - TopShowNode.DEFAULT_HEIGHT)
        })
    self.factoryListView:setAnchorPoint(cc.p(0,0))
    self.factoryListView:addTo(self.uiLayer)

    for k,v in pairs(data.factory) do
        local item = self.factoryListView:newItem()
        item:setItemSize(FactoryShowNode.DEFAULT_WIDTH, FactoryShowNode.DEFAULT_HEIGHT)
        local content = FactoryShowNode.new({title=k})
        content:setContentSize(FactoryShowNode.DEFAULT_WIDTH, FactoryShowNode.DEFAULT_HEIGHT)
        content:setAnchorPoint(cc.p(0,0))
        item:addContent(content)
        self.factoryListView:addItem(item)
        content:refresh(k,v)
    end
    self.factoryListView:reload()

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.tick))
    self:scheduleUpdate()
end

function FirstScene:showPop()

end

function FirstScene:showFactory()

end

function FirstScene:onExit()
end



return FirstScene
