---
title: 如何成为一名优秀的架构师
tags:
  - 架构师
categories:
  - 进阶心法
date: 2021-05-29 20:02:01
---

![](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210530144741.png)

> 码字不宜，你的赞将是我持续更新创作的动力。

架构师，是一个神秘而又神圣的存在，每个刚入行的程序员提及于此，无不露出心驰神往而又望而生畏的复杂神情。

 <!-- more -->

然而，如何成为一名架构师却一直没有一个统一的路径，本周末参与了 QCon，会上郭东白老师的分享对我启发很大，之前自己也学习过一些关于架构师的课，于此，一起聊聊我心中的所想。

## 兼职架构师 & 全职架构师

一般地，那些因为还内部技术债或者由于业务机会优先，面对内部积累问题的复杂度较高时自行解决某个问题的角色称之为兼职架构师，他的真实身份可能是一个软件开发工程师、项目经理等。但是由于机会驱动或内部临时需要架构师这样一个角色时，他站出来了，我们称之为兼职架构师。

相对应的，全职架构师的就是指在一个异构组织内，由于长期地战略需要，或者竞争带来目标的不确定性而需要的这样一种角色。由他来制定方案，别人进行实施。

无论是全职架构师还是兼职架构师，其核心能力都是要具备一定的架构能力，**集众家之所长，虑时事、虑事实、虑实事、虑适时、虑实时**，当你具备这“5 虑”，还需要具备一定的宏观视角和微观视角，时刻以一种跳入跳出的姿势来看待问题，躬身入局，才能做到既纵观全局，又细致入微。

## 架构师的生存之必要条件一：目标正确

不论是刚入门的兼职架构师还是资深的全职架构师，最常见的架构失误就是对限制条件和目标价值产生理解偏差。

一个优秀的架构师应该具备对软件做出正确的设计和决策的基本能力，在做这些决策时往往需要考虑很多限制条件，如：时间成本、人力成本、资金成本、范围要求、质量要求、组织结构等，架构师从来不是独行侠，他是上承需求，下接实现的一种角色。上承需求就需要我们经常的走进客户，了解他们的真实需求及体验反馈；下接实现就需要我们根据客户的需求（产品经理的需求）来对业务分解，从而架构出高可用、高扩展、高伸缩性的系统架构。架构说到底还是为业务赋能，脱离了业务的架构只是一堆空壳子，即使满足了上面的 “三高” ，它也不是一个成功的架构。

一个好的架构还应该具备最大化某种价值的能力，如：社会价值、商业价值、员工价值、某种能力（高可用、高扩展、高伸缩性等等）、代码寿命等。当然，这也是技术服务业务的一种体现。

## 架构师总是必要的吗？

灵魂三问：

- 你们公司有架构师这个角色吗？
- 你们公司目前需要架构师这个角色吗？
- 你觉得你们公司的架构师做的架构能提升你们的业务质量吗？

不一定。小的软件研发机构不一定需要全职架构师。因为架构和设计能力是个基本的软件研发者的能力，每个研发或多或少都具备。全职架构师只有在足够激烈的竞争环境下，复杂的组织中，长期视角和顶层设计缺乏，团队合作低效的情况下才创造足够大的价值。

**对任何一家公司，架构师不是必要的，但是架构设计永远是必要的。**

## 架构师的生存之必要条件二：能力满足

![](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210530111258.png)

想要成为一个架构师首先要具备图中的基本能力，只有满足了这些能力，才能更大化的创造价值，能够基于当前资源做出最好的权衡取舍，最低成本的满足用户的需求，基于业务控制技术方向，控制公司整体风险，为未来扩展做好规划。

## 架构如何才能抵制熵增呢？

> 孤立系统总是趋向于熵增，最终达到熵的最大状态，也就是系统的最混乱无序状态。但是，对开放系统而言，由于它可以将内部能量交换产生的熵增通过向环境释放热量的方式转移，所以开放系统有可能趋向熵减而达到有序状态。熵增的热力学理论与几率学理论结合，产生形而上的哲学指导意义：事物的混乱程度越高，则其几率越大。

通俗的讲就是系统会随着时间的推移变得越来越乱。

具体到软件系统，随着时间的推移，无论是开发还是维护，都会增加系统的复杂度，越多的代码进入，则越容易造成混乱，软件架构也越容易被破坏。因此，软件架构在设计时就要考虑如何抵制熵增的问题。

总体而言，我觉得可以从四个方面来减少熵增的产生：

首先，**从架构设计本身出发。**架构设计中，要充分考虑未来的可变性，将系统中的可变部分和不可变部分在前期就分析出来，将易变部分进行隔离。使用设计原则和设计模式，从软件的整体上把握架构的演化方向，从而提前识别开发和维护对架构的影响。

其次，**架构必须要在团队中取得一致的认识。** 尤其是技术团队中，任何一名开发人员都应该充分理解软件架构，明确自己的代码在整体中的位置，与其他组件的关系和通讯渠道。无论采用何种开发模型，都不应该因此放弃架构在开发人员认知中的重要性。只有如此，组件开发人员才能在整体架构下进行局部设计，并且能保持架构风格的延续性。否则就易于出现局部结构不符合整体架构，从而引发系统走向混乱。

再次，**设计评审或代码评审也可以有效减少熵增的发生。** 设计评审是实现之前的预防，代码评审是实现中的质量保证，两者都可以对架构的一致性起到保证作用，而且在具体的实现中可以反作用于架构的调整，是架构师、技术经理经常采用的管理方法。

最后，**就是主动调整架构。** 架构师不可能预测未来，当变化来临时，要主动的调整架构以适应变化，而不是被动的迁就，靠代码技巧来应对变化。那样的话，就已经从架构上主动进行了熵增，是混乱之源。

## 成为一个优秀架构师的充分条件是什么？

![](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210530112140.png)

> 圣家族大教堂（加泰罗尼亚语：Basílica i Temple Expiatori de la Sagrada Família），又译作神圣家族大教堂，简称圣家堂（Sagrada Família），是位于西班牙加泰罗尼亚巴塞罗那的一座罗马天主教大型教堂，由西班牙建筑师安东尼奥·高迪（1852–1926）设计。尽管教堂还未竣工，但已被联合国教科文组织选为世界遗产。2010年11月，教皇本笃十六世将教堂封为宗座圣殿。

一个优秀的架构师要为一个组织创造出好的设计。

### 1. 一个好的设计是一个发现和创造的过程，不是靠记忆和知识。
<!-- ##- 架构师要有途径的保障他的设计的高质量交付。 -->

架构之美在于悟。 信息世界是无中生有创造出来的，我们不需要去记忆，而是要找到创造背后的骨架和逻辑。

**架构即创造。**

学架构在于匠心和悟心。它靠的是悟，不是记忆。**用思考的方式去记忆，而不是用记忆的方式去思考。**

一个优秀的架构师，如何构建需求分析能力，尤其是需求的预判能力？

**首先，归纳总结能力很重要。** 分析现象背后的原因，并对未来可能性进行推测。判断错了并不要紧，分析一下你的推测哪些地方漏判了，哪些重要信息没有考虑到。
**另外，批判精神也同样至关重要。** 批判不是无中生有的批评，而是切实找到技术中存在的效率瓶颈和心智负担。尤其在你看经典书籍的时候，要善于找出现状与书的历史背景差异，总结技术演进的螺旋上升之路，培养科学的批判方法论。

### 2. 一个好的设计必须要有更持久的外部适应性（技术实现对未来需求和外部环境变化的适应性）

![](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210530114623.png)

我们通过对多个外部机会的抽象可以得到一个领域的产品化方案，通过对多个领域的产品化方案抽象可以得到一个架构，抽象有助于记忆，因为骨架需要逻辑的自洽。这种抽象能力之所以重要，是因为它是融会贯通、疏通整个信息世界的知识脉络的关键。当你做到对世界的认知可宏观、可微观，自然一切皆在掌握。我们的核心目标是以架构为导向，抽象出系统的骨架，融会贯通，把这些领域知识串起来，拼出完整的信息世界的版图。

抽象的最终目标也是为了提升技术实现的外部适应性，只有你的架构抽象的足够好，最终反哺到业务的模型才能足够多。

## 架构师成长之术一：先要宽度还是先要深度？

![](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210530132527.png)

![](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210530135433.png)

**至少在一个领域的深度是扩展宽度的前提条件。** 架构师并不是全才，但是在你想要成为一个架构师之前，你首先应该至少具备在某一个领域的深度，成为该领域的专家，这样不仅能够有一定的话语权，也能从你该领域的光环影射到其他领域，让你具备一定的隐性魅力。

Tom 在计算机图形学方面取得过在世界范围内都很有影响力的成就，那他来做架构师，至少大家会觉得他有一个方面是能服众的，而且具备某个领域成就的人本身就已经反映出来他本身的智商、学习能力、自制力等综合素养，再去扩展宽度也是水到渠成的。

宽度和广度如何训练呢？架构师的思考深度和实战经验远远比学历和知识重要，建议在研究机构或大公司里尽快练出深度之后到小公司里赌命求广度！

## 架构师成长之术二：深度思考和复盘

![](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210530135134.png)

架构师的价值创造来自于独立、理性的、有深度的思考。从技术视角看业务，从业务中发现技术机会。通过复盘发现思考漏洞，提升思考质量。

![](https://cdn.jsdelivr.net/gh/rocwong-cn/assets/imags/20210530140021.png)

深度思考能力的提升在于多进行独立思考，而不是一味的寻找现有的别人的解决方案往自己的业务实例中套。独立思考就要求我们有理性的思维、批判性的思维、敢于发出质疑并尝试提出自己的解决方案，在尊重事实和规律的前提下，基于洞察和推理挑战常规，鼓励创新，敢于创新。当你做到这些后，你就离发现真理，引领变革不远了。

一个好的架构是被创造出来的，靠的是高质量的洞察和对真理的持续逼近。

## 架构师成长之术三：全职架构师的成长过程及价值创造

架构师的价值创造点选择主要集中在：

- 为软件系统找到更好的整体设计
- 为组织创造更高效的研发体系
- 为企业的未来做技术布局

成长过程也能由浅入深的分为以下四个等级：

- 项目级：解决技术难题，提升专业领域的技术深度，获取口碑和机会；
- 系统级：从周边场景过渡到关键场景，款系统跨领域做出正确技术选择和风险取舍；
- 组织级：帮助组织做出艰难但是正确的选择，在多个团队间寻找长期提升的研发效率的方法；
- 企业级：为企业做前瞻性架构布局且取得持续商业成功

在这个持续进化的过程中，经验能力和勇气的提升尤为重要。经验自然不用多数，来源于面对复杂场景下满足业务需求的能力。勇气更多的时候指的是，面对无人敢承担的责任与重担时，你敢接过单子的勇气；来自于需要跨多个团队、部门协调资源时你敢向前一步的决心；来自于发生故障、线上问题时你敢于站在团队前面抗起责任的坚毅（敢于背锅）。

在架构师成长的过程中，对环境也有严格的要求，不是任何环境都适于架构师的成长，架构师需要企业对创新和探索的信任、授权、时间和资源的可调度、可支配。更需要一个包容和求真的企业文化，要求企业对错误有容忍性，基于理性的思考，实证和互相尊重的思想碰撞环境。

## 最后，优秀架构师的正确打开方式

一个优秀的架构师应该是一个德才兼备的人。

- 德：有良知，为人正直，以企业长期利益优先；有勇气，有勇气面临冲突，坚持引导组织做正确的事。
- 才：要求架构师有眼光，有深度的业务理解，看到并能抓住好的机会；善思考，有足够的技术视野，找到正确的技术和组织设计。

一个优秀的架构师始于理性思考，成于科学实践。

- 架构师的价值创造来自于独立, 理性的, 有深度的思考。
- 一个好的架构是被发现的, 靠的高质量的洞察和对真理的持续逼近。
- 架构师要基于良知为组织持续做出正确判断。
- 长期感召力来自于良知和成功经验所带来的信心和勇气。

架构师需要放下技术人的身段，学会 “共情”。与用户共情，理解用户的所思所想。与开发人员共情，理解技术人的所思所想。与公司共情，理解公司的发展诉求。架构师需要学会 “认同他人，反思迭代自己”。不要在不了解背景的情况下，随意推翻别人写的代码，而理由可能仅仅是不符合你的个人风格。当然反过来完全看不到项目的问题同样要不得，但这往往是受限于个人能力。要提升自己的架构水平，需要在实践中不断反思，不断在自我否定中成长。

最后希望大家看完本篇本章都有所得，有所悟，如果对于文章中的观点有任何疑问或者不认同的地方，欢迎您在评论区留言，一起交流，共同进步！
