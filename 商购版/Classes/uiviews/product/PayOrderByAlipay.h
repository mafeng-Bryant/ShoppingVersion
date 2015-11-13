//
//  PayOrderByAlipay.h
//  shopping
//
//  Created by yunlai on 13-3-5.
//
//

#import <Foundation/Foundation.h>

@interface PayOrderByAlipay : NSObject<UIAlertViewDelegate>

/*
 *@brief 订单支付
 *
 *@param orderPrice 订单价格
 *@param orderID 订单id
 *@param name 订单名字
 *@param desc 订单描述
 *
 *@return 支付是否成功
 */
+ (BOOL) payOrder:(float)orderPrice withOrderID:(NSString*)orderID withOrderName:(NSString*)name withDesc:(NSString*)desc;

@end
