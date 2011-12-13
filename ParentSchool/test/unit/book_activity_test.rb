require File.dirname(__FILE__) + '/../test_helper'

class BookActivityTest < ActiveSupport::TestCase

  def test_apply
    #19点前，非当批
    #用户存在，状态0
    ba1 = BookActivity.apply('13862905548', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba1
    #用户存在，状态1
    ba2 = BookActivity.apply('15996522778', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba2
    #用户存在，状态2
    ba3 = BookActivity.apply('13584626755', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba3
    #用户存在，状态3
    ba4 = BookActivity.apply('13912289628', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba4
    #用户存在，状态4
    ba5 = BookActivity.apply('13921600148', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba5
    #用户存在，状态5
    ba6 = BookActivity.apply('15190976046', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba6
    #用户存在，状态6
    ba7 = BookActivity.apply('13921486269', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba7
    #用户不存在
    ba8 = BookActivity.apply('1000000000', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba8

    #19点前，当批
    #用户存在，状态0
    ba9 = BookActivity.apply('13862905548', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba9
    #用户存在，状态1
    ba10 = BookActivity.apply('15996522778', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba10
    #用户存在，状态2
    ba11 = BookActivity.apply('13584626755', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba11
    #用户存在，状态3
    ba12 = BookActivity.apply('13912289628', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba12
    #用户存在，状态4
    ba13 = BookActivity.apply('13921600148', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba13
    #用户存在，状态5
    ba14 = BookActivity.apply('15190976046', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba14
    #用户存在，状态6
    ba15 = BookActivity.apply('13921486269', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba15
    #用户不存在
    ba16 = BookActivity.apply('1000000000', '1')
    assert_equal "0::抱歉，申领尚未开始！", ba16

    #21点后，非当批
    #用户存在，状态0
    ba17 = BookActivity.apply('13862905548', '1')
    assert_equal "0::抱歉，申领已经结束！", ba17
    #用户存在，状态1
    ba18 = BookActivity.apply('15996522778', '1')
    assert_equal "0::抱歉，申领已经结束！", ba18
    #用户存在，状态2
    ba19 = BookActivity.apply('13584626755', '1')
    assert_equal "0::抱歉，申领已经结束！", ba19
    #用户存在，状态3
    ba20 = BookActivity.apply('13912289628', '1')
    assert_equal "0::抱歉，申领已经结束！", ba20
    #用户存在，状态4
    ba21 = BookActivity.apply('13921600148', '1')
    assert_equal "0::抱歉，申领已经结束！", ba21
    #用户存在，状态5
    ba22 = BookActivity.apply('15190976046', '1')
    assert_equal "0::抱歉，申领已经结束！", ba22
    #用户存在，状态6
    ba23 = BookActivity.apply('13921486269', '1')
    assert_equal "0::抱歉，申领已经结束！", ba23
    #用户不存在
    ba24 = BookActivity.apply('1000000000', '1')
    assert_equal "0::抱歉，申领已经结束！", ba24

    #21点后，当批
    #用户存在，状态0
    ba25 = BookActivity.apply('13862905548', '1')
    assert_equal "0::抱歉，申领已经结束！", ba25
    #用户存在，状态1
    ba26 = BookActivity.apply('15996522778', '1')
    assert_equal "0::抱歉，申领已经结束！", ba26
    #用户存在，状态2
    ba27 = BookActivity.apply('13584626755', '1')
    assert_equal "0::抱歉，申领已经结束！", ba27
    #用户存在，状态3
    ba28 = BookActivity.apply('13912289628', '1')
    assert_equal "0::抱歉，申领已经结束！", ba28
    #用户存在，状态4
    ba29 = BookActivity.apply('13921600148', '1')
    assert_equal "0::抱歉，申领已经结束！", ba29
    #用户存在，状态5
    ba30 = BookActivity.apply('15190976046', '1')
    assert_equal "0::抱歉，申领已经结束！", ba30
    #用户存在，状态6
    ba31 = BookActivity.apply('13921486269', '1')
    assert_equal "0::抱歉，申领已经结束！", ba31
    #用户不存在
    ba32 = BookActivity.apply('1000000000', '1')
    assert_equal "0::抱歉，申领已经结束！", ba32

    #活动时间，非当批
    #用户存在，状态0
    ba33 = BookActivity.apply('13862905548', '1')
    assert_equal "0:0:因赠书采取分批申领，您暂不能参与此批图书申领，请您根据短信内容中提供的申领日期进行申领。谢谢！南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。", ba33
    #用户存在，状态1
    ba34 = BookActivity.apply('15996522778', '1')
    assert_equal "0:1:因赠书采取分批申领，您暂不能参与此批图书申领，请您根据短信内容中提供的申领日期进行申领。谢谢！南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。", ba34
    #用户存在，状态2
    ba35 = BookActivity.apply('13584626755', '1')
    assert_equal "0:2:因赠书采取分批申领，您暂不能参与此批图书申领，请您根据短信内容中提供的申领日期进行申领。谢谢！南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。", ba35
    #用户存在，状态3
    ba36 = BookActivity.apply('13912289628', '1')
    assert_equal "0:3:因赠书采取分批申领，您暂不能参与此批图书申领，请您根据短信内容中提供的申领日期进行申领。谢谢！南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。", ba36
    #用户存在，状态4
    ba37 = BookActivity.apply('13921600148', '1')
    assert_equal "0:4:因赠书采取分批申领，您暂不能参与此批图书申领，请您根据短信内容中提供的申领日期进行申领。谢谢！南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。", ba37
    #用户存在，状态5
    ba38 = BookActivity.apply('15190976046', '1')
    assert_equal "0:5:因赠书采取分批申领，您暂不能参与此批图书申领，请您根据短信内容中提供的申领日期进行申领。谢谢！南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。", ba38
    #用户存在，状态6
    ba39 = BookActivity.apply('13921486269', '1')
    assert_equal "0:6:因赠书采取分批申领，您暂不能参与此批图书申领，请您根据短信内容中提供的申领日期进行申领。谢谢！南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。", ba39
    #用户不存在
    ba40 = BookActivity.apply('1000000000', '1')
    assert_equal "0::抱歉您的图书申领失败。南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。", ba40

    #活动时间，当批
    #用户存在，状态0，秒杀成功
    ba41 = BookActivity.apply('13862905548', '1')
    assert_equal "2:0:恭喜！您已成功申领图书《独自成长的小幼虫》，图书将在整个活动结束后，由您孩子所在学校送达。为提高南通市网上家长学校的服务质量，现邀请您填写一份关于您孩子学习的调查问卷，页面将自动跳转。", ba41
    #用户存在，状态0，秒杀失败
    ba42 = BookActivity.apply('13862905548', '1')
    assert_equal "1:0:抱歉您的图书申领失败。南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。", ba42
    #用户存在，状态1
    ba43 = BookActivity.apply('15996522778', '1')
    assert_equal "2:1:您已成功申领图书。因图书数量有限，您不能再次申领。谢谢！为提高南通市网上家长学校的服务质量，现邀请您填写一份关于您孩子学习的调查问卷，页面将自动跳转。", ba43
    #用户存在，状态2，秒杀成功
    ba44 = BookActivity.apply('13584626755', '1')
    assert_equal "2:2:恭喜！您已成功申领图书《独自成长的小幼虫》，图书将在整个活动结束后，由您孩子所在学校送达。为提高南通市网上家长学校的服务质量，现邀请您填写一份关于您孩子学习的调查问卷，页面将自动跳转。", ba44
    #用户存在，状态2，秒杀失败
    ba45 = BookActivity.apply('13584626755', '1')
    assert_equal "1:2:抱歉您的图书申领失败。南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。", ba45
    #用户存在，状态3，秒杀成功
    ba46 = BookActivity.apply('13912289628', '1')
    assert_equal "2:3:恭喜！您已成功申领图书《独自成长的小幼虫》，图书将在整个活动结束后，由您孩子所在学校送达。", ba46
    #用户存在，状态3，秒杀失败
    ba47 = BookActivity.apply('13912289628', '1')
    assert_equal "1:3:抱歉您的图书申领失败。南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。", ba47
    #用户存在，状态4
    ba48 = BookActivity.apply('13921600148', '1')
    assert_equal "0:4:恭喜！您已成功获赠图书《独自成长的小幼虫》，图书将在整个活动结束后，由您孩子所在学校送达。", ba48
    #用户存在，状态5
    ba49 = BookActivity.apply('15190976046', '1')
    assert_equal "0:5:您已成功申领图书。因图书数量有限，您不能再次申领。谢谢！", ba49
    #用户存在，状态6，秒杀成功
    ba50 = BookActivity.apply('13921486269', '1')
    assert_equal "2:6:恭喜！您已成功申领图书《独自成长的小幼虫》，图书将在整个活动结束后，由您孩子所在学校送达。", ba50
    #用户存在，状态6，秒杀失败
    ba51 = BookActivity.apply('13921486269', '1')
    assert_equal "1:6:抱歉您的图书申领失败。南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。", ba51
    #用户不存在
    ba52 = BookActivity.apply('1000000000', '1')
    assert_equal "0::抱歉您的图书申领失败。南通市网上家长学校邀请您参加图书抽奖活动，页面将自动跳转。", ba52
  end

end
