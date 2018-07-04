/**
 * SkyPortalSoapStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class SkyPortalSoapStub extends org.apache.axis.client.Stub implements net.ivoa.SkyPortal.SkyPortalSoap {
    private java.util.Vector cachedSerClasses = new java.util.Vector();
    private java.util.Vector cachedSerQNames = new java.util.Vector();
    private java.util.Vector cachedSerFactories = new java.util.Vector();
    private java.util.Vector cachedDeserFactories = new java.util.Vector();

    static org.apache.axis.description.OperationDesc [] _operations;

    static {
        _operations = new org.apache.axis.description.OperationDesc[15];
        _initOperationDesc1();
        _initOperationDesc2();
    }

    private static void _initOperationDesc1(){
        org.apache.axis.description.OperationDesc oper;
        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("SubmitPlan");
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ep"), new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ExecPlan"), net.ivoa.SkyPortal.ExecPlan.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "VOData"));
        oper.setReturnClass(net.ivoa.SkyPortal.VOData.class);
        oper.setReturnQName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "SubmitPlanResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[0] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("MakePlan");
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "qry"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "planid"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "long"), long.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "outputType"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ExecPlan"));
        oper.setReturnClass(net.ivoa.SkyPortal.ExecPlan.class);
        oper.setReturnQName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "MakePlanResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[1] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("SubmitDistributedQuery");
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "qry"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "outputType"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "VOData"));
        oper.setReturnClass(net.ivoa.SkyPortal.VOData.class);
        oper.setReturnQName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "SubmitDistributedQueryResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[2] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("SubmitDistributedQuerySigma");
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "qry"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "outputType"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "MyDataSigma"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "double"), double.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "VOData"));
        oper.setReturnClass(net.ivoa.SkyPortal.VOData.class);
        oper.setReturnQName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "SubmitDistributedQuerySigmaResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[3] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("SubmitQuery");
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "qry"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "node"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "format"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "VOData"));
        oper.setReturnClass(net.ivoa.SkyPortal.VOData.class);
        oper.setReturnQName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "SubmitQueryResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[4] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("GetAllSkyNodesVOTable");
        oper.setReturnType(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "VOTABLE"));
        oper.setReturnClass(fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VOTABLE.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "GetAllSkyNodesVOTableResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[5] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("GetAllSkyNodes");
        oper.setReturnType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">>GetAllSkyNodesResponse>GetAllSkyNodesResult"));
        oper.setReturnClass(net.ivoa.SkyPortal.__GetAllSkyNodesResponse_GetAllSkyNodesResult.class);
        oper.setReturnQName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetAllSkyNodesResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[6] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("GetTables");
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "node"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ArrayOfMetaTable"));
        oper.setReturnClass(net.ivoa.SkyPortal.ArrayOfMetaTable.class);
        oper.setReturnQName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetTablesResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[7] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("GetMetaColumns");
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "node"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "table"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ArrayOfMetaColumn"));
        oper.setReturnClass(net.ivoa.SkyPortal.ArrayOfMetaColumn.class);
        oper.setReturnQName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetMetaColumnsResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[8] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("NodeContainsColumn");
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "node"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "table"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "column"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        oper.setReturnClass(boolean.class);
        oper.setReturnQName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "NodeContainsColumnResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[9] = oper;

    }

    private static void _initOperationDesc2(){
        org.apache.axis.description.OperationDesc oper;
        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("UploadTable");
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "data"), new javax.xml.namespace.QName("SkyPortal.ivoa.net", "VOData"), net.ivoa.SkyPortal.VOData.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "format"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(java.lang.String.class);
        oper.setReturnQName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "UploadTableResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[10] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("GetColumns");
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "node"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "table"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ArrayOfString"));
        oper.setReturnClass(net.ivoa.SkyPortal.ArrayOfString.class);
        oper.setReturnQName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetColumnsResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[11] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("GetTableInfo");
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "node"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "table"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "MetaTable"));
        oper.setReturnClass(net.ivoa.SkyPortal.MetaTable.class);
        oper.setReturnQName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetTableInfoResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[12] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("GetMetaTables");
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "node"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ArrayOfMetaTable"));
        oper.setReturnClass(net.ivoa.SkyPortal.ArrayOfMetaTable.class);
        oper.setReturnQName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetMetaTablesResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[13] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("GetColumnInfo");
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "node"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "table"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "column"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "MetaColumn"));
        oper.setReturnClass(net.ivoa.SkyPortal.MetaColumn.class);
        oper.setReturnQName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetColumnInfoResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[14] = oper;

    }

    public SkyPortalSoapStub() throws org.apache.axis.AxisFault {
         this(null);
    }

    public SkyPortalSoapStub(java.net.URL endpointURL, javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
         this(service);
         super.cachedEndpoint = endpointURL;
    }

    public SkyPortalSoapStub(javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
        if (service == null) {
            super.service = new org.apache.axis.client.Service();
        } else {
            super.service = service;
        }
            java.lang.Class cls;
            javax.xml.namespace.QName qName;
            java.lang.Class beansf = org.apache.axis.encoding.ser.BeanSerializerFactory.class;
            java.lang.Class beandf = org.apache.axis.encoding.ser.BeanDeserializerFactory.class;
            java.lang.Class enumsf = org.apache.axis.encoding.ser.EnumSerializerFactory.class;
            java.lang.Class enumdf = org.apache.axis.encoding.ser.EnumDeserializerFactory.class;
            java.lang.Class arraysf = org.apache.axis.encoding.ser.ArraySerializerFactory.class;
            java.lang.Class arraydf = org.apache.axis.encoding.ser.ArrayDeserializerFactory.class;
            java.lang.Class simplesf = org.apache.axis.encoding.ser.SimpleSerializerFactory.class;
            java.lang.Class simpledf = org.apache.axis.encoding.ser.SimpleDeserializerFactory.class;
            java.lang.Class simplelistsf = org.apache.axis.encoding.ser.SimpleListSerializerFactory.class;
            java.lang.Class simplelistdf = org.apache.axis.encoding.ser.SimpleListDeserializerFactory.class;
        addBindings0();
        addBindings1();
    }

    private void addBindings0() {
            java.lang.Class cls;
            javax.xml.namespace.QName qName;
            java.lang.Class beansf = org.apache.axis.encoding.ser.BeanSerializerFactory.class;
            java.lang.Class beandf = org.apache.axis.encoding.ser.BeanDeserializerFactory.class;
            java.lang.Class enumsf = org.apache.axis.encoding.ser.EnumSerializerFactory.class;
            java.lang.Class enumdf = org.apache.axis.encoding.ser.EnumDeserializerFactory.class;
            java.lang.Class arraysf = org.apache.axis.encoding.ser.ArraySerializerFactory.class;
            java.lang.Class arraydf = org.apache.axis.encoding.ser.ArrayDeserializerFactory.class;
            java.lang.Class simplesf = org.apache.axis.encoding.ser.SimpleSerializerFactory.class;
            java.lang.Class simpledf = org.apache.axis.encoding.ser.SimpleDeserializerFactory.class;
            java.lang.Class simplelistsf = org.apache.axis.encoding.ser.SimpleListSerializerFactory.class;
            java.lang.Class simplelistdf = org.apache.axis.encoding.ser.SimpleListDeserializerFactory.class;
            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "orderDirectionType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.OrderDirectionType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "coord3SizeType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.Coord3SizeType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "selectType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.SelectType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "unaryExprType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.UnaryExprType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetTableInfo");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetTableInfo.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "xMatchType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.XMatchType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "astronTimeTypeReferenceUnit");
            cachedSerQNames.add(qName);
            cls = nvo_coords.AstronTimeTypeReferenceUnit.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:nvo-region", "negationType");
            cachedSerQNames.add(qName);
            cls = nvo_region.NegationType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "BINARY");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.BINARY.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "likePredType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.LikePredType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ArrayOfMetaColumn");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal.ArrayOfMetaColumn.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", "MetaTable");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal.MetaTable.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "timeScaleType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.TimeScaleType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">SubmitQueryResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._SubmitQueryResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">MakePlanResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._MakePlanResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "comparisonPredType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.ComparisonPredType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", "MetaColumn");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal.MetaColumn.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "COOSYSSystem");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.COOSYSSystem.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:nvo-region", "regionType");
            cachedSerQNames.add(qName);
            cls = nvo_region.RegionType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "orderType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.OrderType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">UploadTableResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._UploadTableResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "notLikePredType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.NotLikePredType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "posCoordType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.PosCoordType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-region", "constraintType");
            cachedSerQNames.add(qName);
            cls = nvo_region.ConstraintType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "angleUnitType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.AngleUnitType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "coord2ValueType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.Coord2ValueType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "closedExprType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.ClosedExprType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "vel2VectorType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.Vel2VectorType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-region", "shapeType");
            cachedSerQNames.add(qName);
            cls = nvo_region.ShapeType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetColumns");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetColumns.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ErrorData");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal.ErrorData.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "intersectionSearchType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.IntersectionSearchType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "MAX");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.MAX.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "anyTEXT");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.AnyTEXT.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">SubmitPlanResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._SubmitPlanResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-region", "convexHullType");
            cachedSerQNames.add(qName);
            cls = nvo_region.ConvexHullType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "COOSYS");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.COOSYS.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "coordsType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.CoordsType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetAllSkyNodesVOTable");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetAllSkyNodesVOTable.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">SubmitDistributedQuerySigma");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._SubmitDistributedQuerySigma.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", "DataSetData");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal.DataSetData.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "coordSpectralValueType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.CoordSpectralValueType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "FIELD");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.FIELD.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "stringType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.StringType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "OPTION");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.OPTION.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "STREAMActuate");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.STREAMActuate.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "unaryOperatorType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.UnaryOperatorType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "trigonometricFunctionNameType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.TrigonometricFunctionNameType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "posUnitType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.PosUnitType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "allOrDistinctType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.AllOrDistinctType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetColumnsResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetColumnsResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "velScalarType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.VelScalarType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "selectionItemType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.SelectionItemType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-region", "polygonType");
            cachedSerQNames.add(qName);
            cls = nvo_region.PolygonType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "astronTimeTypeReference");
            cachedSerQNames.add(qName);
            cls = nvo_coords.AstronTimeTypeReference.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(simplesf);
            cachedDeserFactories.add(simpledf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "astronTimeType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.AstronTimeType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "VALUESType");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VALUESType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:nvo-region", "sectorType");
            cachedSerQNames.add(qName);
            cls = nvo_region.SectorType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "allSelectionItemType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.AllSelectionItemType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "integerType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.IntegerType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "TABLEDATA");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.TABLEDATA.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-region", "unionType");
            cachedSerQNames.add(qName);
            cls = nvo_region.UnionType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "astronTimeTypeRelativeTimeUnit");
            cachedSerQNames.add(qName);
            cls = nvo_coords.AstronTimeTypeRelativeTimeUnit.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "mathFunctionNameType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.MathFunctionNameType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "coord2SizeType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.Coord2SizeType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "literalType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.LiteralType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "aliasSelectionItemType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.AliasSelectionItemType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "binaryExprType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.BinaryExprType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "TABLE");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.TABLE.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "pos3VectorType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.Pos3VectorType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "RESOURCE");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.RESOURCE.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetTablesResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetTablesResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "pos2VectorType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.Pos2VectorType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">UploadTable");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._UploadTable.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "RESOURCEType");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.RESOURCEType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "closedSearchType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.ClosedSearchType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "coordSpectralType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.CoordSpectralType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "GROUP");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.GROUP.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "STREAM");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.STREAM.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(simplesf);
            cachedDeserFactories.add(simpledf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "vel3VectorType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.Vel3VectorType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-region", "circleType");
            cachedSerQNames.add(qName);
            cls = nvo_region.CircleType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetMetaTablesResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetMetaTablesResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "numberType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.NumberType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "realType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.RealType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", "PlanElement");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal.PlanElement.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ExecPlan");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal.ExecPlan.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "PARAM");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.PARAM.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ArrayOfPlanElement");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal.ArrayOfPlanElement.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "searchType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.SearchType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetMetaColumnsResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetMetaColumnsResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ArrayOfMetaTable");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal.ArrayOfMetaTable.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "includeTableType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.IncludeTableType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "betweenPredType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.BetweenPredType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "notBetweenPredType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.NotBetweenPredType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetAllSkyNodes");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetAllSkyNodes.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetTableInfoResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetTableInfoResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "selectionLimitType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.SelectionLimitType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">>GetAllSkyNodesResponse>GetAllSkyNodesResult");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal.__GetAllSkyNodesResponse_GetAllSkyNodesResult.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "STREAMType");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.STREAMType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetColumnInfo");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetColumnInfo.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

    }
    private void addBindings1() {
            java.lang.Class cls;
            javax.xml.namespace.QName qName;
            java.lang.Class beansf = org.apache.axis.encoding.ser.BeanSerializerFactory.class;
            java.lang.Class beandf = org.apache.axis.encoding.ser.BeanDeserializerFactory.class;
            java.lang.Class enumsf = org.apache.axis.encoding.ser.EnumSerializerFactory.class;
            java.lang.Class enumdf = org.apache.axis.encoding.ser.EnumDeserializerFactory.class;
            java.lang.Class arraysf = org.apache.axis.encoding.ser.ArraySerializerFactory.class;
            java.lang.Class arraydf = org.apache.axis.encoding.ser.ArrayDeserializerFactory.class;
            java.lang.Class simplesf = org.apache.axis.encoding.ser.SimpleSerializerFactory.class;
            java.lang.Class simpledf = org.apache.axis.encoding.ser.SimpleDeserializerFactory.class;
            java.lang.Class simplelistsf = org.apache.axis.encoding.ser.SimpleListSerializerFactory.class;
            java.lang.Class simplelistdf = org.apache.axis.encoding.ser.SimpleListDeserializerFactory.class;
            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "encodingType");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.EncodingType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "coord3ValueType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.Coord3ValueType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">NodeContainsColumnResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._NodeContainsColumnResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "LINKContentrole");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.LINKContentrole.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "unionSearchType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.UnionSearchType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ArrayOfString");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal.ArrayOfString.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "tableType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.TableType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "yesno");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.Yesno.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "astronTimeTypeReferenceTime_base");
            cachedSerQNames.add(qName);
            cls = nvo_coords.AstronTimeTypeReferenceTime_base.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "archiveTableType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.ArchiveTableType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "trigonometricFunctionType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.TrigonometricFunctionType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">SubmitDistributedQuerySigmaResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._SubmitDistributedQuerySigmaResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-region", "ellipseType");
            cachedSerQNames.add(qName);
            cls = nvo_region.EllipseType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "aggregateFunctionNameType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.AggregateFunctionNameType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "selectionListType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.SelectionListType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "astronTimeTypeRelativeTime");
            cachedSerQNames.add(qName);
            cls = nvo_coords.AstronTimeTypeRelativeTime.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(simplesf);
            cachedDeserFactories.add(simpledf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "MIN");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.MIN.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "VOTABLEVersion");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VOTABLEVersion.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "xMatchTableAliasType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.XMatchTableAliasType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", "VOTableData");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal.VOTableData.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "TD");
            cachedSerQNames.add(qName);
            cls = java.lang.String.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(simplesf);
            cachedDeserFactories.add(simpledf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "VOTABLE");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VOTABLE.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "coordTimeValueType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.CoordTimeValueType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "atomType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.AtomType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "selectionOptionType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.SelectionOptionType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "orderExpressionType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.OrderExpressionType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">MakePlan");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._MakePlan.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">SubmitDistributedQueryResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._SubmitDistributedQueryResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "columnReferenceType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.ColumnReferenceType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "scalarExpressionType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.ScalarExpressionType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "FITS");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.FITS.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", "VOData");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal.VOData.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "fromTableType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.FromTableType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetTables");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetTables.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-region", "intersectionType");
            cachedSerQNames.add(qName);
            cls = nvo_region.IntersectionType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "havingType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.HavingType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "comparisonType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.ComparisonType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "posScalarType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.PosScalarType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "LINK");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.LINK.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "TR");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.TR.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetColumnInfoResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetColumnInfoResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "functionType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.FunctionType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "INFO");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.INFO.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">DataSet");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._DataSet.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "ArrayOfDouble");
            cachedSerQNames.add(qName);
            cls = nvo_coords.ArrayOfDouble.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">SubmitDistributedQuery");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._SubmitDistributedQuery.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "orderOptionType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.OrderOptionType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">DataSetData>DataSet");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._DataSetData_DataSet.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">SubmitQuery");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._SubmitQuery.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", "StringData");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal.StringData.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetMetaColumns");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetMetaColumns.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-region", "vertexType");
            cachedSerQNames.add(qName);
            cls = nvo_region.VertexType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "dataType");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.DataType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "velCoordType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.VelCoordType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetAllSkyNodesResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetAllSkyNodesResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">SubmitPlan");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._SubmitPlan.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "DATA");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.DATA.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "coordTimeType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.CoordTimeType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "PARAMref");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.PARAMref.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "ArrayOfChoice1");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.ArrayOfChoice1.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "whereType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.WhereType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-region", "smallCircleType");
            cachedSerQNames.add(qName);
            cls = nvo_region.SmallCircleType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "inverseSearchType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.InverseSearchType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "FIELDref");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.FIELDref.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetAllSkyNodesVOTableResponse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetAllSkyNodesVOTableResponse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "groupByType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.GroupByType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">GetMetaTables");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._GetMetaTables.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "velTimeUnitType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.VelTimeUnitType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "dropTableType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.DropTableType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-region", "convexType");
            cachedSerQNames.add(qName);
            cls = nvo_region.ConvexType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "coordValueType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.CoordValueType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("urn:nvo-coords", "spectralUnitType");
            cachedSerQNames.add(qName);
            cls = nvo_coords.SpectralUnitType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "mathFunctionType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.MathFunctionType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "binaryOperatorType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.BinaryOperatorType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://vizier.u-strasbg.fr/xml/VOTable-1.1.xsd", "VALUES");
            cachedSerQNames.add(qName);
            cls = fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VALUES.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "regionSearchType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.RegionSearchType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "aggregateFunctionType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.AggregateFunctionType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "fromType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ADQL.v0_7_4.FromType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("SkyPortal.ivoa.net", ">NodeContainsColumn");
            cachedSerQNames.add(qName);
            cls = net.ivoa.SkyPortal._NodeContainsColumn.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

    }

    private org.apache.axis.client.Call createCall() throws java.rmi.RemoteException {
        try {
            org.apache.axis.client.Call _call =
                    (org.apache.axis.client.Call) super.service.createCall();
            if (super.maintainSessionSet) {
                _call.setMaintainSession(super.maintainSession);
            }
            if (super.cachedUsername != null) {
                _call.setUsername(super.cachedUsername);
            }
            if (super.cachedPassword != null) {
                _call.setPassword(super.cachedPassword);
            }
            if (super.cachedEndpoint != null) {
                _call.setTargetEndpointAddress(super.cachedEndpoint);
            }
            if (super.cachedTimeout != null) {
                _call.setTimeout(super.cachedTimeout);
            }
            if (super.cachedPortName != null) {
                _call.setPortName(super.cachedPortName);
            }
            java.util.Enumeration keys = super.cachedProperties.keys();
            while (keys.hasMoreElements()) {
                java.lang.String key = (java.lang.String) keys.nextElement();
                _call.setProperty(key, super.cachedProperties.get(key));
            }
            // All the type mapping information is registered
            // when the first call is made.
            // The type mapping information is actually registered in
            // the TypeMappingRegistry of the service, which
            // is the reason why registration is only needed for the first call.
            synchronized (this) {
                if (firstCall()) {
                    // must set encoding style before registering serializers
                    _call.setEncodingStyle(null);
                    for (int i = 0; i < cachedSerFactories.size(); ++i) {
                        java.lang.Class cls = (java.lang.Class) cachedSerClasses.get(i);
                        javax.xml.namespace.QName qName =
                                (javax.xml.namespace.QName) cachedSerQNames.get(i);
                        java.lang.Class sf = (java.lang.Class)
                                 cachedSerFactories.get(i);
                        java.lang.Class df = (java.lang.Class)
                                 cachedDeserFactories.get(i);
                        _call.registerTypeMapping(cls, qName, sf, df, false);
                    }
                }
            }
            return _call;
        }
        catch (java.lang.Throwable _t) {
            throw new org.apache.axis.AxisFault("Failure trying to get the Call object", _t);
        }
    }

    public net.ivoa.SkyPortal.VOData submitPlan(net.ivoa.SkyPortal.ExecPlan submitPlanEp) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[0]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/SubmitPlan");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "SubmitPlan"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {submitPlanEp});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.SkyPortal.VOData) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.SkyPortal.VOData) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.SkyPortal.VOData.class);
            }
        }
    }

    public net.ivoa.SkyPortal.ExecPlan makePlan(java.lang.String makePlanQry, long makePlanPlanid, java.lang.String makePlanOutputType) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[1]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/MakePlan");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "MakePlan"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {makePlanQry, new java.lang.Long(makePlanPlanid), makePlanOutputType});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.SkyPortal.ExecPlan) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.SkyPortal.ExecPlan) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.SkyPortal.ExecPlan.class);
            }
        }
    }

    public net.ivoa.SkyPortal.VOData submitDistributedQuery(java.lang.String submitDistributedQueryQry, java.lang.String submitDistributedQueryOutputType) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[2]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/SubmitDistributedQuery");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "SubmitDistributedQuery"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {submitDistributedQueryQry, submitDistributedQueryOutputType});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.SkyPortal.VOData) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.SkyPortal.VOData) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.SkyPortal.VOData.class);
            }
        }
    }

    public net.ivoa.SkyPortal.VOData submitDistributedQuerySigma(java.lang.String submitDistributedQuerySigmaQry, java.lang.String submitDistributedQuerySigmaOutputType, double submitDistributedQuerySigmaMyDataSigma) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[3]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/SubmitDistributedQuerySigma");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "SubmitDistributedQuerySigma"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {submitDistributedQuerySigmaQry, submitDistributedQuerySigmaOutputType, new java.lang.Double(submitDistributedQuerySigmaMyDataSigma)});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.SkyPortal.VOData) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.SkyPortal.VOData) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.SkyPortal.VOData.class);
            }
        }
    }

    public net.ivoa.SkyPortal.VOData submitQuery(java.lang.String submitQueryQry, java.lang.String submitQueryNode, java.lang.String submitQueryFormat) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[4]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/SubmitQuery");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "SubmitQuery"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {submitQueryQry, submitQueryNode, submitQueryFormat});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.SkyPortal.VOData) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.SkyPortal.VOData) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.SkyPortal.VOData.class);
            }
        }
    }

    public fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VOTABLE getAllSkyNodesVOTable() throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[5]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/GetAllSkyNodesVOTable");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetAllSkyNodesVOTable"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VOTABLE) _resp;
            } catch (java.lang.Exception _exception) {
                return (fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VOTABLE) org.apache.axis.utils.JavaUtils.convert(_resp, fr.u_strasbg.vizier.xml.VOTable_1_1_xsd.VOTABLE.class);
            }
        }
    }

    public net.ivoa.SkyPortal.__GetAllSkyNodesResponse_GetAllSkyNodesResult getAllSkyNodes() throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[6]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/GetAllSkyNodes");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetAllSkyNodes"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.SkyPortal.__GetAllSkyNodesResponse_GetAllSkyNodesResult) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.SkyPortal.__GetAllSkyNodesResponse_GetAllSkyNodesResult) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.SkyPortal.__GetAllSkyNodesResponse_GetAllSkyNodesResult.class);
            }
        }
    }

    public net.ivoa.SkyPortal.ArrayOfMetaTable getTables(java.lang.String getTablesNode) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[7]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/GetTables");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetTables"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {getTablesNode});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.SkyPortal.ArrayOfMetaTable) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.SkyPortal.ArrayOfMetaTable) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.SkyPortal.ArrayOfMetaTable.class);
            }
        }
    }

    public net.ivoa.SkyPortal.ArrayOfMetaColumn getMetaColumns(java.lang.String getMetaColumnsNode, java.lang.String getMetaColumnsTable) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[8]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/GetMetaColumns");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetMetaColumns"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {getMetaColumnsNode, getMetaColumnsTable});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.SkyPortal.ArrayOfMetaColumn) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.SkyPortal.ArrayOfMetaColumn) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.SkyPortal.ArrayOfMetaColumn.class);
            }
        }
    }

    public boolean nodeContainsColumn(java.lang.String nodeContainsColumnNode, java.lang.String nodeContainsColumnTable, java.lang.String nodeContainsColumnColumn) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[9]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/NodeContainsColumn");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "NodeContainsColumn"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {nodeContainsColumnNode, nodeContainsColumnTable, nodeContainsColumnColumn});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return ((java.lang.Boolean) _resp).booleanValue();
            } catch (java.lang.Exception _exception) {
                return ((java.lang.Boolean) org.apache.axis.utils.JavaUtils.convert(_resp, boolean.class)).booleanValue();
            }
        }
    }

    public java.lang.String uploadTable(net.ivoa.SkyPortal.VOData uploadTableData, int uploadTableFormat) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[10]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/UploadTable");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "UploadTable"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {uploadTableData, new java.lang.Integer(uploadTableFormat)});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (java.lang.String) _resp;
            } catch (java.lang.Exception _exception) {
                return (java.lang.String) org.apache.axis.utils.JavaUtils.convert(_resp, java.lang.String.class);
            }
        }
    }

    public net.ivoa.SkyPortal.ArrayOfString getColumns(java.lang.String getColumnsNode, java.lang.String getColumnsTable) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[11]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/GetColumns");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetColumns"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {getColumnsNode, getColumnsTable});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.SkyPortal.ArrayOfString) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.SkyPortal.ArrayOfString) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.SkyPortal.ArrayOfString.class);
            }
        }
    }

    public net.ivoa.SkyPortal.MetaTable getTableInfo(java.lang.String getTableInfoNode, java.lang.String getTableInfoTable) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[12]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/GetTableInfo");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetTableInfo"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {getTableInfoNode, getTableInfoTable});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.SkyPortal.MetaTable) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.SkyPortal.MetaTable) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.SkyPortal.MetaTable.class);
            }
        }
    }

    public net.ivoa.SkyPortal.ArrayOfMetaTable getMetaTables(java.lang.String getMetaTablesNode) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[13]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/GetMetaTables");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetMetaTables"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {getMetaTablesNode});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.SkyPortal.ArrayOfMetaTable) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.SkyPortal.ArrayOfMetaTable) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.SkyPortal.ArrayOfMetaTable.class);
            }
        }
    }

    public net.ivoa.SkyPortal.MetaColumn getColumnInfo(java.lang.String getColumnInfoNode, java.lang.String getColumnInfoTable, java.lang.String getColumnInfoColumn) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[14]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("SkyPortal.ivoa.net/GetColumnInfo");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "GetColumnInfo"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {getColumnInfoNode, getColumnInfoTable, getColumnInfoColumn});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.SkyPortal.MetaColumn) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.SkyPortal.MetaColumn) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.SkyPortal.MetaColumn.class);
            }
        }
    }

}
