use Transit
-- =============================================
-- 1. Clear and reset all lookup tables
-- =============================================
-- 🚍 Vehicle Types
DELETE FROM [Lookup].LkpVehicleType;
DBCC CHECKIDENT ('[Lookup].LkpVehicleType', RESEED, 0);

-- 🔧 Vehicle Statuses
DELETE FROM [Lookup].LkpVehicleStatus;
DBCC CHECKIDENT ('[Lookup].LkpVehicleStatus', RESEED, 0);


delete from  [Transport].Route

-- 🗺 Route Statuses
DELETE FROM [Lookup].LkpRouteStatus;
DBCC CHECKIDENT ('[Lookup].LkpRouteStatus', RESEED, 0);

-- 🚌 Journey Statuses
DELETE FROM [Lookup].LkpJourneyStatus;
DBCC CHECKIDENT ('[Lookup].LkpJourneyStatus', RESEED, 0);

-- 🖥 Device Types
DELETE FROM [Lookup].LkpDeviceType;
DBCC CHECKIDENT ('[Lookup].LkpDeviceType', RESEED, 0);

-- 📟 Device Statuses
DELETE FROM [Lookup].LkpDeviceStatus;
DBCC CHECKIDENT ('[Lookup].LkpDeviceStatus', RESEED, 0);

-- 💳 Card Types
DELETE FROM [Lookup].LkpCardType;
DBCC CHECKIDENT ('[Lookup].LkpCardType', RESEED, 0);

-- 💳 Card Statuses
DELETE FROM [Lookup].LkpCardStatus;
DBCC CHECKIDENT ('[Lookup].LkpCardStatus', RESEED, 0);

-- 💰 Payment Methods
DELETE FROM [Lookup].LkpPaymentMethod;
DBCC CHECKIDENT ('[Lookup].LkpPaymentMethod', RESEED, 0);

-- 🏪 Sales Channels
DELETE FROM [Lookup].LkpSalesChannel;
DBCC CHECKIDENT ('[Lookup].LkpSalesChannel', RESEED, 0);

-- 🛠 Maintenance Types
DELETE FROM [Lookup].LkpMaintenanceType;
DBCC CHECKIDENT ('[Lookup].LkpMaintenanceType', RESEED, 0);

-- 🧩 Part Categories
DELETE FROM [Lookup].LkpPartCategory;
DBCC CHECKIDENT ('[Lookup].LkpPartCategory', RESEED, 0);

-- 👷 Roles
DELETE FROM [Lookup].LkpRole;
DBCC CHECKIDENT ('[Lookup].LkpRole', RESEED, 0);

-- 🏢 Departments
DELETE FROM [Lookup].LkpDepartment;
DBCC CHECKIDENT ('[Lookup].LkpDepartment', RESEED, 0);

-- ⏰ Shift Types
DELETE FROM [Lookup].LkpShiftType;
DBCC CHECKIDENT ('[Lookup].LkpShiftType', RESEED, 0);

-- ⛽ Fuel Types
DELETE FROM [Lookup].LkpFuelType;
DBCC CHECKIDENT ('[Lookup].LkpFuelType', RESEED, 0);


-- =============================================
-- 2. Insert static reference data into lookup tables
-- =============================================

--  Vehicle Types
INSERT INTO [Lookup].LkpVehicleType (TypeCode, Label_EN, Label_FA) VALUES
('BUS_STD', 'Standard Bus', N'اتوبوس عادی'),
('BUS_EXP', 'Express Bus', N'اتوبوس تندرو'),
('VAN_MINI', 'Mini Van', N'ون کوچک');

--  Vehicle Statuses
INSERT INTO [Lookup].LkpVehicleStatus (StatusCode, Label_EN, Label_FA) VALUES
('Active', 'Active', N'فعال'),
('Repair', 'Under Repair', N'در تعمیر'),
('OutOfService', 'Out of Service', N'خارج از سرویس');

--  Route Statuses
INSERT INTO [Lookup].LkpRouteStatus (StatusCode, Label_EN, Label_FA) VALUES
('Active', 'Active', N'فعال'),
('Inactive', 'Inactive', N'غیرفعال');

--  Journey Statuses
INSERT INTO [Lookup].LkpJourneyStatus (StatusCode, Label_EN, Label_FA) VALUES
('Scheduled', 'Scheduled', N'زمان‌بندی شده'),
('InService', 'In Service', N'در حال اجرا'),
('Completed', 'Completed', N'تکمیل شده'),
('Cancelled', 'Cancelled', N'لغو شده');

--  Device Types
INSERT INTO [Lookup].LkpDeviceType (TypeCode, Label_EN, Label_FA) VALUES
('BusValidator', 'Bus Validator', N'دستگاه اعتبارسنجی اتوبوس'),
('GateReader', 'Gate Reader', N'خوانش‌گر گیت');

--  Device Statuses
INSERT INTO [Lookup].LkpDeviceStatus (StatusCode, Label_EN, Label_FA) VALUES
('Active', 'Active', N'فعال'),
('Inactive', 'Inactive', N'غیرفعال'),
('Faulty', 'Faulty', N'معیوب');

--  Card Types
INSERT INTO [Lookup].LkpCardType (TypeCode, Label_EN, Label_FA) VALUES
('Anonymous', 'Anonymous', N'عادی'),
('Student', 'Student', N'دانش‌آموز'),
('Teacher', 'Cultural', N'فرهنگی'),
('Veteran', 'Veteran', N'نظامی'),
('Disabled', 'Disabled', N'معلول');

--  Card Statuses
INSERT INTO [Lookup].LkpCardStatus (StatusCode, Label_EN, Label_FA) VALUES
('Active', 'Active', N'فعال'),
('Blocked', 'Blocked', N'مسدود'),
('Expired', 'Expired', N'منقضی شده');

--  Payment Methods
INSERT INTO [Lookup].LkpPaymentMethod (MethodCode, Label_EN, Label_FA) VALUES
('Card', 'Card', N'کارت'),
('Ticket', 'Ticket', N'بلیط');

--  Sales Channels
INSERT INTO [Lookup].LkpSalesChannel (ChannelCode, Label_EN, Label_FA) VALUES
('MobileApp', 'Mobile App', N'اپلیکیشن موبایل'),
('Kiosk', 'Kiosk', N'کیوسک');

--  Maintenance Types
INSERT INTO [Lookup].LkpMaintenanceType (TypeCode, Label_EN, Label_FA) VALUES
('Preventive', 'Preventive Maintenance', N'نگهداری پیشگیرانه'),
('Corrective', 'Corrective Maintenance', N'نگهداری اصلاحی'),
('Overhaul', 'Overhaul', N'تعمیرات اساسی');

--  Top-Level Part Categories
INSERT INTO [Lookup].LkpPartCategory (ParentCategoryID, CategoryCode, Label_EN, Label_FA) VALUES
(NULL, 'SUSP', 'Suspension', N'سیستم تعلیق'),
(NULL, 'EXH', 'Exhaust', N'اگزوز'),
(NULL, 'COOL', 'Cooling System', N'سیستم خنک‌کننده'),
(NULL, 'FUEL', 'Fuel System', N'سیستم سوخت‌رسانی'),
(NULL, 'STEER', 'Steering', N'فرمان'),
(NULL, 'HVAC', 'HVAC', N'تهویه مطبوع'),
(NULL, 'INT', 'Interior', N'داخلی'),
(NULL, 'ELEC', 'Electrical', N'برقی'),
(NULL, 'WHEEL', 'Wheels', N'چرخ‌ها'),
(NULL, 'SAFETY', 'Safety', N'ایمنی');

--  Second-Level Part Categories
INSERT INTO [Lookup].LkpPartCategory (ParentCategoryID, CategoryCode, Label_EN, Label_FA) VALUES
(1, 'SHOCK', 'Shock Absorber', N'کمک فنر'),
(1, 'SPRING', 'Spring', N'فنر'),
(2, 'MUFFLER', 'Muffler', N'صداخفه‌کن'),
(2, 'PIPE', 'Exhaust Pipe', N'لوله اگزوز'),
(3, 'RADIATOR', 'Radiator', N'رادیاتور'),
(3, 'FAN', 'Cooling Fan', N'فن خنک‌کننده'),
(4, 'FUEL_PUMP', 'Fuel Pump', N'پمپ سوخت'),
(4, 'FUEL_FILTER', 'Fuel Filter', N'فیلتر سوخت'),
(5, 'STEER_WHEEL', 'Steering Wheel', N'فرمان خودرو'),
(6, 'HEATER', 'Heater', N'بخاری'),
(7, 'SEAT', 'Seat', N'صندلی'),
(8, 'LIGHTS', 'Lights', N'چراغ'),
(8, 'SENSORS', 'Sensors', N'سنسورها'),
(9, 'TIRE', 'Tire', N'تایر'),
(10, 'AIRBAG', 'Airbag', N'کیسه هوا'),
(10, 'SEATBELT', 'Seat Belt', N'کمربند ایمنی');

--  Roles
INSERT INTO [Lookup].LkpRole (RoleCode, Label_EN, Label_FA) VALUES
('Driver', 'Driver', N'راننده'),
('Mechanic', 'Mechanic', N'مکانیک'),
('Clerk', 'Clerk', N'کارمند');

--  Departments
INSERT INTO [Lookup].LkpDepartment (DeptCode, Label_EN, Label_FA) VALUES
('OPS', 'Operations', N'عملیات'),
('MAIN', 'Maintenance', N'نگهداری'),
('HR', 'Human Resources', N'منابع انسانی');

--  Shift Types
INSERT INTO [Lookup].LkpShiftType (ShiftCode, Label_EN, Label_FA) VALUES
('Morning', 'Morning Shift', N'شیفت صبح'),
('Night', 'Night Shift', N'شیفت شب'),
('Split', 'Split Shift', N'شیفت تمام وقت');

--  Fuel Types
INSERT INTO [Lookup].LkpFuelType (FuelCode, Label_EN, Label_FA) VALUES
('Gasoline', 'Gasoline', N'بنزین'),
('CNG', 'CNG', N'گاز طبیعی'),
('Diesel', 'Diesel', N'گازوئیل');
