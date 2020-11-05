// const ConvertLib = artifacts.require("ConvertLib");
// const MetaCoin = artifacts.require("MetaCoin");
// const MyERC20Token = artifacts.require("MyERC20Token");
const Cajon = artifacts.require("Cajon");

module.exports = function(deployer) {
    // deployer.deploy(ConvertLib);
    // deployer.link(ConvertLib, MetaCoin);
    // deployer.deploy(MetaCoin);
    // deployer.deploy(MyERC20Token);
    deployer.deploy(Cajon);
};