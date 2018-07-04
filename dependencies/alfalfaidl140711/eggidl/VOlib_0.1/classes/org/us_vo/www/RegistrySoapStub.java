/**
 * RegistrySoapStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package org.us_vo.www;

public class RegistrySoapStub extends org.apache.axis.client.Stub implements org.us_vo.www.RegistrySoap {
    private java.util.Vector cachedSerClasses = new java.util.Vector();
    private java.util.Vector cachedSerQNames = new java.util.Vector();
    private java.util.Vector cachedSerFactories = new java.util.Vector();
    private java.util.Vector cachedDeserFactories = new java.util.Vector();

    static org.apache.axis.description.OperationDesc [] _operations;

    static {
        _operations = new org.apache.axis.description.OperationDesc[7];
        _initOperationDesc1();
    }

    private static void _initOperationDesc1(){
        org.apache.axis.description.OperationDesc oper;
        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("DumpRegistry");
        oper.setReturnType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfSimpleResource"));
        oper.setReturnClass(org.us_vo.www.ArrayOfSimpleResource.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://www.us-vo.org", "DumpRegistryResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[0] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("DumpVOResources");
        oper.setReturnType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ArrayOfResource"));
        oper.setReturnClass(net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://www.us-vo.org", "DumpVOResourcesResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[1] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("QueryVOResource");
        oper.addParameter(new javax.xml.namespace.QName("http://www.us-vo.org", "predicate"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ArrayOfResource"));
        oper.setReturnClass(net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://www.us-vo.org", "QueryVOResourceResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[2] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("QueryResource");
        oper.addParameter(new javax.xml.namespace.QName("http://www.us-vo.org", "predicate"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfDBResource"));
        oper.setReturnClass(org.us_vo.www.ArrayOfDBResource.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://www.us-vo.org", "QueryResourceResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[3] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("QueryRegistry");
        oper.addParameter(new javax.xml.namespace.QName("http://www.us-vo.org", "predicate"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfSimpleResource"));
        oper.setReturnClass(org.us_vo.www.ArrayOfSimpleResource.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://www.us-vo.org", "QueryRegistryResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[4] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("KeywordSearch");
        oper.addParameter(new javax.xml.namespace.QName("http://www.us-vo.org", "keywords"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), java.lang.String.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.addParameter(new javax.xml.namespace.QName("http://www.us-vo.org", "andKeys"), new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"), boolean.class, org.apache.axis.description.ParameterDesc.IN, false, false);
        oper.setReturnType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ArrayOfResource"));
        oper.setReturnClass(net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://www.us-vo.org", "KeywordSearchResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[5] = oper;

        oper = new org.apache.axis.description.OperationDesc();
        oper.setName("Revisions");
        oper.setReturnType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfString"));
        oper.setReturnClass(org.us_vo.www.ArrayOfString.class);
        oper.setReturnQName(new javax.xml.namespace.QName("http://www.us-vo.org", "RevisionsResult"));
        oper.setStyle(org.apache.axis.enum.Style.WRAPPED);
        oper.setUse(org.apache.axis.enum.Use.LITERAL);
        _operations[6] = oper;

    }

    public RegistrySoapStub() throws org.apache.axis.AxisFault {
         this(null);
    }

    public RegistrySoapStub(java.net.URL endpointURL, javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
         this(service);
         super.cachedEndpoint = endpointURL;
    }

    public RegistrySoapStub(javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
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
            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "SkySize");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.SIA.v0_7.SkySize.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "SIACapability");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.SIA.v0_7.SIACapability.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ResourceName");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.ResourceName.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(simplesf);
            cachedDeserFactories.add(simpledf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "DataCollection");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.DataCollection.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VORegistry/v0.3", "Registry");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VORegistry.v0_3.Registry.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Temporal");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.Temporal.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Content");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.Content.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/OpenSkyNode/v0.1", "OpenSkyNode");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.OpenSkyNode.v0_1.OpenSkyNode.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Coverage");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.Coverage.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ArrayOfResource");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Contact");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.Contact.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfResourceRelation");
            cachedSerQNames.add(qName);
            cls = org.us_vo.www.ArrayOfResourceRelation.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.us-vo.org", "ServiceSimpleImageAccess");
            cachedSerQNames.add(qName);
            cls = org.us_vo.www.ServiceSimpleImageAccess.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfString");
            cachedSerQNames.add(qName);
            cls = org.us_vo.www.ArrayOfString.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Relationship");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.Relationship.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.us-vo.org", "ServiceSkyNode");
            cachedSerQNames.add(qName);
            cls = org.us_vo.www.ServiceSkyNode.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.us-vo.org", "ResourceRelation");
            cachedSerQNames.add(qName);
            cls = org.us_vo.www.ResourceRelation.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "CoordFrame");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.CoordFrame.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Spatial");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.Spatial.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "DataType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.DataType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(simplesf);
            cachedDeserFactories.add(simpledf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "SkyService");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.SkyService.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "AngleRange");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.AngleRange.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Capability");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.Capability.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Service");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.Service.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Type");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.Type.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/OpenSkyNode/v0.1", "OSNCapability");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.OpenSkyNode.v0_1.OSNCapability.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Position");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.Position.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ContentLevel");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.ContentLevel.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Curation");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.Curation.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Source");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.Source.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(simplesf);
            cachedDeserFactories.add(simpledf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Resource");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.Resource.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "AccessURL");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.AccessURL.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(simplesf);
            cachedDeserFactories.add(simpledf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "AllSky");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.AllSky.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.us-vo.org", "SimpleResource");
            cachedSerQNames.add(qName);
            cls = org.us_vo.www.SimpleResource.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.us-vo.org", "ServiceCone");
            cachedSerQNames.add(qName);
            cls = org.us_vo.www.ServiceCone.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.us-vo.org", "InterfaceParam");
            cachedSerQNames.add(qName);
            cls = org.us_vo.www.InterfaceParam.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "ImageServiceType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.SIA.v0_7.ImageServiceType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfDBResource");
            cachedSerQNames.add(qName);
            cls = org.us_vo.www.ArrayOfDBResource.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "RelationshipType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.RelationshipType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Region");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.Region.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "CircleRegion");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.CircleRegion.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfResourceInterface");
            cachedSerQNames.add(qName);
            cls = org.us_vo.www.ArrayOfResourceInterface.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "ParamHTTP");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.ParamHTTP.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "WavelengthRange");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.WavelengthRange.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "TabularSkyService");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.TabularSkyService.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Date");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.Date.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(simplesf);
            cachedDeserFactories.add(simpledf);

            qName = new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfSimpleResource");
            cachedSerQNames.add(qName);
            cls = org.us_vo.www.ArrayOfSimpleResource.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "WebBrowser");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.WebBrowser.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Organisation");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.Organisation.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfInterfaceParam");
            cachedSerQNames.add(qName);
            cls = org.us_vo.www.ArrayOfInterfaceParam.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "ImageSize");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.SIA.v0_7.ImageSize.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ResourceStatus");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.ResourceStatus.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Interface");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10._interface.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ConeSearch/v0.3", "CSCapRestriction");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ConeSearch.v0_3.CSCapRestriction.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "CoordRange");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.CoordRange.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.us-vo.org", "ResourceInterface");
            cachedSerQNames.add(qName);
            cls = org.us_vo.www.ResourceInterface.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.us-vo.org", "DBResource");
            cachedSerQNames.add(qName);
            cls = org.us_vo.www.DBResource.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "GLUService");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.GLUService.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Table");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.Table.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VORegistry/v0.3", "Authority");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VORegistry.v0_3.Authority.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/OpenSkyNode/v0.1", "OSNCapRestriction");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.OpenSkyNode.v0_1.OSNCapRestriction.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Spectral");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.Spectral.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Waveband");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.Waveband.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "Creator");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.Creator.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ConeSearch/v0.3", "ConeSearch");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ConeSearch.v0_3.ConeSearch.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "SIACapRestriction");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.SIA.v0_7.SIACapRestriction.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "HTTPQueryType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.HTTPQueryType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Format");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.Format.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(simplesf);
            cachedDeserFactories.add(simpledf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "WebService");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.WebService.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "ScalarDataType");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.ScalarDataType.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Param");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.Param.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/SIA/v0.7", "SimpleImageAccess");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.SIA.v0_7.SimpleImageAccess.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(beansf);
            cachedDeserFactories.add(beandf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VODataService/v0.5", "Rights");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VODataService.v0_5.Rights.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "AccessURLUse");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.VOResource.v0_10.AccessURLUse.class;
            cachedSerClasses.add(cls);
            cachedSerFactories.add(enumsf);
            cachedDeserFactories.add(enumdf);

            qName = new javax.xml.namespace.QName("http://www.ivoa.net/xml/ConeSearch/v0.3", "ConeSearchCapability");
            cachedSerQNames.add(qName);
            cls = net.ivoa.www.xml.ConeSearch.v0_3.ConeSearchCapability.class;
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

    public org.us_vo.www.ArrayOfSimpleResource dumpRegistry() throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[0]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("http://www.us-vo.org/DumpRegistry");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://www.us-vo.org", "DumpRegistry"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (org.us_vo.www.ArrayOfSimpleResource) _resp;
            } catch (java.lang.Exception _exception) {
                return (org.us_vo.www.ArrayOfSimpleResource) org.apache.axis.utils.JavaUtils.convert(_resp, org.us_vo.www.ArrayOfSimpleResource.class);
            }
        }
    }

    public net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource dumpVOResources() throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[1]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("http://www.us-vo.org/DumpVOResources");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://www.us-vo.org", "DumpVOResources"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource.class);
            }
        }
    }

    public net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource queryVOResource(java.lang.String queryVOResourcePredicate) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[2]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("http://www.us-vo.org/QueryVOResource");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://www.us-vo.org", "QueryVOResource"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {queryVOResourcePredicate});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource.class);
            }
        }
    }

    public org.us_vo.www.ArrayOfDBResource queryResource(java.lang.String queryResourcePredicate) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[3]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("http://www.us-vo.org/QueryResource");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://www.us-vo.org", "QueryResource"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {queryResourcePredicate});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (org.us_vo.www.ArrayOfDBResource) _resp;
            } catch (java.lang.Exception _exception) {
                return (org.us_vo.www.ArrayOfDBResource) org.apache.axis.utils.JavaUtils.convert(_resp, org.us_vo.www.ArrayOfDBResource.class);
            }
        }
    }

    public org.us_vo.www.ArrayOfSimpleResource queryRegistry(java.lang.String queryRegistryPredicate) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[4]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("http://www.us-vo.org/QueryRegistry");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://www.us-vo.org", "QueryRegistry"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {queryRegistryPredicate});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (org.us_vo.www.ArrayOfSimpleResource) _resp;
            } catch (java.lang.Exception _exception) {
                return (org.us_vo.www.ArrayOfSimpleResource) org.apache.axis.utils.JavaUtils.convert(_resp, org.us_vo.www.ArrayOfSimpleResource.class);
            }
        }
    }

    public net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource keywordSearch(java.lang.String keywordSearchKeywords, boolean keywordSearchAndKeys) throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[5]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("http://www.us-vo.org/KeywordSearch");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://www.us-vo.org", "KeywordSearch"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {keywordSearchKeywords, new java.lang.Boolean(keywordSearchAndKeys)});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource) _resp;
            } catch (java.lang.Exception _exception) {
                return (net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource) org.apache.axis.utils.JavaUtils.convert(_resp, net.ivoa.www.xml.VOResource.v0_10.ArrayOfResource.class);
            }
        }
    }

    public org.us_vo.www.ArrayOfString revisions() throws java.rmi.RemoteException {
        if (super.cachedEndpoint == null) {
            throw new org.apache.axis.NoEndPointException();
        }
        org.apache.axis.client.Call _call = createCall();
        _call.setOperation(_operations[6]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("http://www.us-vo.org/Revisions");
        _call.setEncodingStyle(null);
        _call.setProperty(org.apache.axis.client.Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new javax.xml.namespace.QName("http://www.us-vo.org", "Revisions"));

        setRequestHeaders(_call);
        setAttachments(_call);
        java.lang.Object _resp = _call.invoke(new java.lang.Object[] {});

        if (_resp instanceof java.rmi.RemoteException) {
            throw (java.rmi.RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (org.us_vo.www.ArrayOfString) _resp;
            } catch (java.lang.Exception _exception) {
                return (org.us_vo.www.ArrayOfString) org.apache.axis.utils.JavaUtils.convert(_resp, org.us_vo.www.ArrayOfString.class);
            }
        }
    }

}
