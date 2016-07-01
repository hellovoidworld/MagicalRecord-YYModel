# MagicalRecord-YYModel
Let YYModel support CoreData object

####使用MagicalRecord对CoreData的二次封装进行数据库操作  
使用cocoapods引入MagicalRecord和YYModel库。  
源码和用法看github就可以了：  
MagicalRecord: [MagicalRecord git](https://github.com/magicalpanda/MagicalRecord)  
YYModel: [YYModel git](https://github.com/ibireme/YYModel)  

---
####使用YYModel自动转换json数据为CoreData模型对象，YYModel不支持CoreData模型的转换，这里利用runtime写了一个分类"NSManagedObject+Common"，用以支持CoreData的转换。

思路是：  
1. 在Entity Class中实现分类中要调用的方法"primaryKeys"用来指定自定义主键，"coreDataModelContainerPropertyGenericClass"指定容器属性（relation）中的元素类，modelPropertyBlacklist屏蔽relation的普通赋值。  
2. 读取json数据，解析成字典。  
3. 使用MagicalRecord创建DB Entity，再使用YYModel赋值。  
4. 使用runtime，探测出此Entity中的relation，并递归调用上一步的创建Entity和赋值逻辑。  
5. 存入数据库。
